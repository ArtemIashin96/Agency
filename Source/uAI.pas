unit uAI;

interface

uses
  uCommon, Forms;

var
  BoardSize: Integer;
  WinLength: Integer;
  Plys: Integer;
  BoardArray: TByte2DArr; //playing board. 0=empty 1=player1 2=player2
  MoveList: TInt2DArr;
  AllDone: Boolean;//flag to signal end of game or quit
  Values: TInt64Arr;
  MoveCount: Int64;
  BoardValue: Int64;

  procedure UpdateBoardValue(r,c: Integer);
  procedure InitMoveList();
  procedure InitBoardArray;
  function AlphaBetaSearch(ply, limit, player: Integer; var bestmove: Integer): Int64;
  function VictoryCheck(): Integer;

implementation

//'changes the global BoardValue based on putting player at r%,c%
procedure UpdateBoardValue(r,c: Integer);
var
  i, j, player, wl: Integer;
  v: Integer;
  pcnt, ocnt: Integer;
begin
  v := 0;
  wl := WinLength - 1;
  player := BoardArray[r, c];
  //'check all possible vertical lines that include r%,
  i := r - wl;
  while i <= r do
  begin
    if (i >= 0) and ((i + wl) <= BOARDSIZE) then
    begin
      pcnt := 0;
      ocnt := 0;
      j := i;
      while j <= (i + wl) do
      begin
        if BoardArray[j, c] = player then
        begin
          if j <> r then
            inc(pcnt);
        end
        else
          if BoardArray[j, c] = 0 then
          begin
          end
          else
            inc(ocnt);
        inc(j);
      end;
      if ocnt > 0 then
      begin
        if pcnt = 0 then
          v := v + Values[ocnt]// 'get points for denying opponent
      end
      else
        v := v + Values[pcnt + 1] - Values[pcnt];// 'get points for increasing length
    end;
    inc(i);
  end;
  //'check all possible horizontal lines that include r%,c%
  i := c - wl;
  while i <= c do
  begin
    if (i >= 0) and ((i + wl) <= BOARDSIZE) then
    begin
      pcnt := 0;
      ocnt := 0;
      j := i;
      while j <= (i + wl) do
      begin
        if BoardArray[r, j] = player then
        begin
          if j <> c then
            inc(pcnt);
        end
        else
          if BoardArray[r, j] = 0 then
          begin
          end
          else
            inc(ocnt);
        inc(j);
      end;
      if ocnt > 0 then
      begin
        if pcnt = 0 then v := v + Values[ocnt]; //'get points for denying opponent
      end
      else
        v := v + Values[pcnt + 1] - Values[pcnt];// 'get points for increasing length
    end;
    inc(i);
  end;
//'check diagonals from top left to bottom right
  i := 0;
  while i <= wl do
  begin
    if ((c - i) >= 0) and (((c - i) + wl) <= BOARDSIZE) and ((r - i) >= 0) and (((r - i) + wl) <= BOARDSIZE) then
    begin
      pcnt := 0;
      ocnt := 0;
      j := 0;
      while j <= wl do
      begin
        if BoardArray[(r - i + j), (c - i + j)] = player then
        begin
          if i <> j then
            inc(pcnt);
        end
        else
          if BoardArray[(r - i + j), (c - i + j)] = 0 then
           begin
           end
           else
             inc(ocnt);
        inc(j);
      end;
      if ocnt > 0 then
      begin
        if pcnt = 0 then v := v + Values[ocnt]; //'get points for denying opponent
      end
      else
        v := v + Values[pcnt + 1] - Values[pcnt];// 'get points for increasing length
    end;
    inc(i);
  end;
//'check diagonals from bottom left to top right
  i := 0;
  while i <= wl do
  begin
    if ((c - i) >= 0) and (((c - i) + wl) <= BOARDSIZE) and (((r + i) - wl) >= 0) and ((r + i) <= BOARDSIZE) then
    begin
      pcnt := 0;
      ocnt := 0;
      j := 0;
      while j <= wl do
      begin
        if BoardArray[(r + i - j), (c - i + j)] = player then
        begin
          if i <> j then
            inc(pcnt);
        end
        else
          if BoardArray[(r + i - j), (c - i + j)] = 0 then
          begin
          end
          else
            inc(ocnt);
        inc(j);
      end;
      if ocnt > 0 then
      begin
        if pcnt = 0 then v := v + Values[ocnt]; //'get points for denying opponent
      end
      else
        v := v + Values[pcnt + 1] - Values[pcnt];// 'get points for increasing length
    end;
    inc(i);
  end;
  if player = 2 then
    v := -v;//  'player 2 likes small boardvalues
  BoardValue := BoardValue + v;
end;

//'load movelist in such a way that centre moves are first in list
procedure InitMoveList();
var
  r, c, i, n, v, lasti: Integer;
  lv: Integer;
  movevalue: TInt2DArr;
begin
  SetLength(movevalue, 2, (BOARDSIZE + 1) * (BOARDSIZE + 1)+1);
//'uses a kind of linked list structure.
//'movevalue(0,x) is the value for square x
//'movevalue(1,x) is the index of the next square
//
//'also init the values table
  lv := 0;
  SetLength(Values, WinLength+1);
  i := 0;
  while i < WinLength+1 do
  begin
    Values[i] := lv;
    lv := lv * 10 + 1;
    inc(i);
  end;

  n := 1;
  movevalue[1,0] := 0;
  r := 0;
  while r < BOARDSIZE+1 do
  begin
    c := 0;
    while c < BOARDSIZE+1 do
    begin
      v := (Abs(r - BOARDSIZE div 2) + 1) * (Abs(c - BOARDSIZE div 2) + 1);
      movevalue[0, n] := v;
      i := movevalue[1, 0];
      lasti := 0;
      while i <> 0 do
      begin
        if v < movevalue[0, i] then //'insert
        begin
          movevalue[1, n] := i;
          movevalue[1, lasti] := n;
          Break;
        end;
        lasti := i;
        i := movevalue[1, i];
      end;
      if i = 0 then //'no insertion, add to end
      begin
        movevalue[1, n] := 0;
        movevalue[1, lasti] := n;
      end;
      inc(n);
      inc(c);
    end;
    inc(r);
  end;
  i := movevalue[1, 0];
  n := 0;
  while i <> 0 do
  begin
    MoveList[n, 0] := i - 1;
    MoveList[n, 1] := 0;  //'not picked
    i := movevalue[1, i];
    inc(n);
  end;
end;

procedure InitBoardArray;
var
  i, j: Integer;
begin
  i := 0;
  while i < Length(BoardArray) do
  begin
    j := 0;
    while j < Length(BoardArray[i]) do
    begin
      BoardArray[i,j] := 0;
      inc(j);
    end;
    inc(i);
  end;
end;

//'returns the value of the board
function AlphaBetaSearch(ply, limit, player: Integer; var bestmove: Integer): Int64;
var
  best, i, n, v, move: Integer;
  r, c, otherplayer: Integer;
  lastbv: Integer;
begin
  Result := -1;
  //'aborts if the branch it is searching is worse than the limit
  if AllDone then
    Exit;

  if ply <> 0 then //'not at bottom of recursive branch yet...
  begin
    n := (BOARDSIZE + 1) * (BOARDSIZE + 1) - 1;
    if player = 1 then
    begin
      best := -1000000000;
      otherplayer := 2;
    end
    else
    begin
      best := 1000000000;
      otherplayer := 1;
    end;
    //'check all possible moves from this location...
    i := 0;
    while i <= n do
    begin
      if MoveList[i, 1] = 0 then
      begin
        r := MoveList[i, 0] div (BOARDSIZE + 1);
        c := MoveList[i, 0] mod (BOARDSIZE + 1);
        //'we've selected a move...
        MoveList[i, 1] := player;//        '...so remove it from list...
        BoardArray[r, c] := player;//     '...and update board...
        lastbv := BoardValue;//            '...but save the old boardvalue for later
        UpdateBoardValue(r, c);//         'calculate the new boardvalue
        v := AlphaBetaSearch(ply - 1, best, otherplayer, move);// 'and recursively follow branch
        if AllDone then
          Break;
        //'return board and movelist to original state
        BoardValue := lastbv;
        BoardArray[r, c] := 0;
        MoveList[i, 1] := 0;
        if player = 1 Then //' Pick largest
        begin
          if v > best then
          begin
            best := v;
            bestmove := i;
          end;
          if v > limit then //'we are past the limit, meaning there is no point exploring this branch further
            Break;
        end
        else //'Pick smallest
        begin
          if v < best then
          begin
            best := v;
            bestmove := i;
          end;
          if v < limit then
            Break;
        end;
      end;
      inc(i);
    end;
    AlphaBetaSearch := best;
  end
  else  //'we are at the bottom of the branch. Just return the board value
  begin
    MoveCount := MoveCount + 1;
    AlphaBetaSearch := BoardValue;
  end;
end;

//'checks for victory. Returns 1 or 2 for player 1 or 2 or 0 if no one won.
function VictoryCheck(): Integer;
var
  r, c, i, pl, r1, c1, r2, c2, j, wl: Integer;
begin
  wl := WinLength - 1;
  r := 0;
  while r <= BOARDSIZE do
  begin
    c := 0;
    while c <= BOARDSIZE do
    begin
        if r <= (BOARDSIZE - wl) then //'calculate vertical
        begin
          pl := 0;
          i := 0;
          r1 := r;
          while r1 <= (r + wl) do
          begin
            case BoardArray[r1, c] of
            0: //'nothing  
              begin
              end;
            1:
              begin
                case pl of
                0:  
                  begin
                    pl := 1;
                    i := 1;
                  end;
                1: inc(i);
                2:
                  begin
                    i := 0;
                    Break;
                  end;
                end;
              end;
            2:
              begin
                case pl of
                0:
                  begin
                    pl := 2;
                    i := 1;
                  end;
                2: inc(i);
                1:
                  begin
                    i := 0;
                    Break;
                  end;
                end;              
              end;
            end;
            inc(r1);
          end;
          if i = WinLength then
          begin
            Result := pl;
            Exit;
          end;
        end; 
        if c <= (BOARDSIZE - wl) then //'calculate horizontal
        begin
          pl := 0;
          i := 0;
          c1 := c;
          while c1 <= (c + wl) do
          begin
            case BoardArray[r, c1] of
            0: //'nothing  
              begin
              end;
            1:
              begin
                case pl of
                0:  
                  begin
                    pl := 1;
                    i := 1;
                  end;
                1:
                  begin
                    i := i + 1;
                  end;
                2:
                  begin
                    i := 0;
                    Break;
                  end;
                end;
              end;
            2:
              begin
                case pl of
                0:
                  begin
                    pl := 2;
                    i := 1;
                  end;
                2:
                  begin
                    i := i + 1;
                  end;
                1:
                  begin
                    i := 0;
                    Break;
                  end;
                end;              
              end;
            end;
            inc(c1);
          end;
          if i = WinLength then
          begin
            Result := pl;
            Exit;
          end;
        end;
        if (r <= (BOARDSIZE - wl)) and (c <= (BOARDSIZE - wl)) then //'diag1
        begin
          i := 0;
          pl := 0;
          j := 0;
          while j <= wl do
          begin
            case BoardArray[r + j, c + j] of
            0: //'nothing  
              begin
              end;
            1:
              begin
                case pl of
                0:  
                  begin
                    pl := 1;
                    i := 1;
                  end;
                1: inc(i);
                2:
                  begin
                    i := 0;
                    Break;
                  end;
                end;
              end;
            2:
              begin
                case pl of
                0:
                  begin
                    pl := 2;
                    i := 1;
                  end;
                2: inc(i);
                1:
                  begin
                    i := 0;
                    Break;
                  end;
                end;              
              end;
            end;
            inc(j);
          end;
          if i = WinLength then
          begin
            Result := pl;
            Exit;
          end;
        end;
        If (r <= (BOARDSIZE - wl)) and (c >= wl) then  //'diag2
        begin
          i := 0;
          pl := 0;
          j := 0;
          while j <= wl do
          begin
            case BoardArray[r + j, c - j] of
            0: //'nothing  
              begin
              end;
            1:
              begin
                case pl of
                0:  
                  begin
                    pl := 1;
                    i := 1;
                  end;
                1: inc(i);
                2:
                  begin
                    i := 0;
                    Break;
                  end;
                end;
              end;
            2:
              begin
                case pl of
                0:
                  begin
                    pl := 2;
                    i := 1;
                  end;
                2: inc(i);
                1:
                  begin
                    i := 0;
                    Break;
                  end;
                end;              
              end;
            end;
            inc(j);
          end;
          if i = WinLength then
          begin
            Result := pl;
            Exit;
          end;
        end;
      inc(c);
    end;
    inc(r);
  end;
  Application.ProcessMessages;
  Result := 0;
end;

end.
