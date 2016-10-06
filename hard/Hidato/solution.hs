-- Credits to zandekar ! -> www.reddit.com/user/zandekar

import Data.Char
import Data.Map as Map
import Data.List
import Data.Set as Set

inp1 =
    ".  33 35 .  .  x  x x\n\
    \.  .  24 22 .  x  x x\n\
    \.  .  .  21 .  .  x x\n\
    \.  26 .  13 40 11 x x\n\
    \27 .  .  .  9  .  1 x\n\
    \x  x  .  .  18 .  . x\n\
    \x  x  x  x  .  7  . .\n\
    \x  x  x  x  x  x  5 ."

inp7 =
    ".  1  x\n\
    \.  .  x\n\
    \7  .  .\n\
    \x  5  ."

inp2 = 
    "1 . . . . . . .\n\
    \x x x x x x x .\n\
    \. . . . . . . .\n\
    \. x x x x x x x\n\
    \. . . . . . . .\n\
    \x x x x x x x .\n\
    \. . . . . . . .\n\
    \. x x x x x x x\n\
    \. . . . . . . ."

inp3 = "1 ."

inp4 =
    "1 .\n\
    \x .\n\
    \5 ."

inp5 =
    ".  4  5  16\n\
    \8  6  .  . \n\
    \.  12 .  14\n\
    \10 .  13 1"

inp6 =
    "1  .  .  23 .  . \n\
    \11 .  3  .  .  18\n\
    \.  13 .  .  .  . \n\
    \.  .  .  .  26 . \n\
    \8  .  .  15 .  30\n\
    \.  .  36 .  .  31"

type Height = Integer
type Width  = Integer
type Pos    = (Integer, Integer)
type Nums = Set Integer -- we avoid duplicate numbers by checking membership in this set
data Board  = Board (Height, Width) Nums (Map Pos Tile)
            deriving (Eq,Show)

data Tile
    = Blank
    | Nogo
    | Tile Integer
      deriving (Eq, Show)

mkBoard :: String -> Board
mkBoard s =
    let lws = Prelude.map words $ lines s
        sz  = boardSize lws
        ns  = Set.fromList $
              Prelude.map read $
              Prelude.filter isNum $
              concat lws
    in Board sz ns $ go (0,0) lws
  where
  go :: Pos -> [[String]] -> Map (Integer,Integer) Tile
  go _      []          = Map.empty
  go (r, c) ([]:es)     = go (r+1, 0) es
  go (r, c) ((s:ss):es) =
      Map.insert (r,c) (mkTile s) $ go (r,c+1) (ss:es)

isNum = all isDigit
boardSize lws = ( fromIntegral $ length lws, fromIntegral $ length (head lws))

mkTile "." = Blank
mkTile "x" = Nogo
mkTile  s  = Tile $ read s

-- where do we start?
findLowestNum :: Board -> (Pos, Integer)
findLowestNum (Board _ _ mp) = go ((0,0),10000) $ Map.toList mp
  where
  go (p,i) []         = (p,i)
  go (p,i) ((q,Tile j):es) =
    if j < i
    then go (q,j) es
    else go (p,i) es
  go (p,i) ((q,_):es) = go (p,i) es

findPath :: Maybe Pos -> Integer -> Board -> [Board]
findPath Nothing _ _ = []
findPath (Just p) i (Board sz ns b) =
   case Map.lookup p b of
     Just Blank    ->
         if Set.member i ns -- check if a tile with this number exists
         then []
         else findPaths p (i+1) (Board sz ns (Map.insert p (Tile i) b))
     Just Nogo     -> []
     Just (Tile j) ->
         if i /= j
         then []
         else findPaths p (i+1) (Board sz ns b)
     _ -> [Board sz ns b]

findPaths :: Pos -> Integer -> Board -> [Board]
findPaths p j b@(Board sz ns _) =
    if not (hasBlank b)
    then [b]
    else concat [ findPath (nw sz p) j b
                , findPath (n  sz p) j b
                , findPath (ne sz p) j b
                , findPath (e  sz p) j b
                , findPath (se sz p) j b
                , findPath (s  sz p) j b
                , findPath (sw sz p) j b
                , findPath (w  sz p) j b
                ]

nw _ (0, c) = Nothing
nw _ (r, 0) = Nothing
nw _ (r,c) = Just (r-1,c-1)

ne _      (0,c) = Nothing
ne (_, w) (r,c)
    | c == w-1 = Nothing
    | otherwise = Just (r-1,c+1)

se (h, w) (r, c)
   | r == h-1 = Nothing
   | c == w-1 = Nothing
   | otherwise = Just (r+1,c+1)

sw (h,w) (r,c)
   | r == h-1 = Nothing
   | c == 0 = Nothing
   | otherwise = Just (r+1,c-1)

n (h,w) (r,c)
    | r == 0 = Nothing
    | otherwise = Just (r-1,c)

e (h,w) (r,c)
    | c == w-1 = Nothing
    | otherwise = Just (r,c+1)

s (h,w) (r,c)
    | r == h-1 = Nothing
    | otherwise = Just (r+1,c)

w (h,w) (r,c)
    | c == 0 = Nothing
    | otherwise = Just (r,c-1)

findBoard s = do
    let b     = mkBoard s
        (p,i) = findLowestNum b
    mapM_ showBoard $ findPath (Just p) i b

hasBlank :: Board -> Bool
hasBlank (Board _ _ b) = not $ Map.null $ Map.filter (==Blank) b

isTile (Tile i) = True
isTile _ = False

unTile (Tile i) = i

showBoard :: Board -> IO ()
showBoard (Board (h,w) _ b) = go (0,0) $ Map.toList b
  where
  go (i,j) [] = putStrLn "\n\n"
  go (i,j) ((p, e):es) 
    | j == w = do putStrLn "\n"; go (i+1,0) ((p,e):es)
    | otherwise = do putStr (tileStr e) ; go (i,j+1) es

tileStr (Tile i) = pad $ show i
tileStr Nogo     = "x  "

pad s =
    let l = length s
    in s ++ (take (3-l) $ repeat ' ')

main = do
    findBoard inp1
    findBoard inp2
    findBoard inp3
    findBoard inp4
    findBoard inp5
    findBoard inp6