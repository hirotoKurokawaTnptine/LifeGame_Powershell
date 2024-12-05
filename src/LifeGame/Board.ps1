using namespace System.Collections.Generic
using namespace System.Collections

class GenerateBoard {
    static $ALIVE = 1
    static $EMPTY = 0

    static [List[List[int]]]randomBoard([int]$board_size) {
        $rnd = [System.Random]::new()
        return 1..$board_size | . { begin{[List[List[int]]]$list=@()} process{
            [List[int]]$x = @($rnd.GetItems(@([GenerateBoard]::ALIVE, [GenerateBoard]::EMPTY), $board_size))
            $list.Add($x)
        } end{ return $list }}
    }
}