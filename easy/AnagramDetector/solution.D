// Credits to cym13 !! Check him in http://www.reddit.com/user/cym13

import std.stdio;
import std.array;
import std.algorithm;

auto norm(string text) {
    import std.uni;
    return text.toLower.filter!isAlpha.array.sort;
}

void main(string[] args) {
    auto parts   = args[1].split("?");
    bool anagram = parts[0].norm == parts[1].norm;
    writeln(parts[0], "is", anagram ? "" : " NOT", " an anagram of", parts[1]);
}