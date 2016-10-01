// Credits to Otsoaero ! Catch him in -> https://www.reddit.com/user/Otsoaero

object Main{

    def gcd(a: Int, b: Int): Int =
        if (b == 0) a
        else gcd(b, a % b)

    def simplifyFrac(a: Int, b: Int) = 
        (a / gcd(a, b), b / gcd(a, b)) 

    def main(args: Array[String]): Unit = {}

}
