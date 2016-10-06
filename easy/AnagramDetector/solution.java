/** Credits to thorwing!! Check him in www.reddit.com/user/thorwing */

//Imports.

public class Solution {

    public static void main(String[] args) throws IOException{
            Files.lines(Paths.get("input")).map(Solution::toAnagramSentence).forEach(System.out::println);
    }

    static String toAnagramSentence(String input){
            String[] compares = input.split(" \\? ");
            int[] word1 = toSortedIntArray(compares[0]);
            int[] word2 = toSortedIntArray(compares[1]);
            String midText = Arrays.equals(word1, word2) ? " is an anagram of " : " is NOT an anagram of ";
            return compares[0] + midText + compares[1];
    }

    static int[] toSortedIntArray(String input){
            return input.toLowerCase().chars().filter(Character::isAlphabetic).sorted().toArray();
    }

}
