# Intcode

As of 2020-09-20, this is the code for my solution for the [2019 Advent Of Code Day 2](https://adventofcode.com/2019/day/2). I've added a PDF printout of the instructions for that question in this repository, so I won't get into the full details here. The outline of the problem is this:

* Part 1 reveals that there is a sequence of integers that represent a computer program that updates its instructions while it runs. Your task is to write an interpreter that can run the program and determine the 'output' of the program (the value in the first memory slot).
* Part 2 adds in new terminology that captures how users think about the programs (namely 'noun' and 'verb') and ask you to identify the noun and verb, within given bounds, that will generate a given output.

## My approach

I'm reading David West's [_Object Thinking_](https://www.goodreads.com/book/show/43940.Object_Thinking), and that has me thinking about object oriented design and how it contrasts with what we might call class oriented design. That distinction, as described in the book, is fascinating to me, and it is showing me that much of what I've historically considered 'good' OOP in Ruby is actually not *object* thinking but is, instead, *class* thinking. I used this small project as a way to explore object thinking and how it might differ from my natural tendencies.
