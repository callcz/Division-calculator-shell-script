# Division-calculator-shell-script
Usage: ./division.sh [OPTIONS] [DIVIDEND] [DIVISOR] [SCALE]
        Default SCALE val is '10'
        example:
                `./division.sh 3 2 1` as '3 / 2 scale=1'
options:
  -     Using shell pipes as input sources.
        example: `echo 3 2 1| ./division.sh - - -` as '3 / 2 scale=1'
                 `echo 3| ./division.sh - 2` as '3 / 2 scale=10'
                 `echo 0.2| ./division.sh 3 - 4` as '3 / 0.2 scale=4'
                 `echo 16| ./division.sh 3 2 -` as '3 / 2 scale=16'
  --help,-h     List this help.

example:
$./division.sh 10 3
3.3333333333

$./division.sh 3.1415926 2.718281828459045 20
1.15572733007633862892

$echo 3.1415926 |./division.sh - 2.718281828459045
1.1557273301

$echo -3.1415926 |./division.sh 2.718281828459045 -
0.8652559942
