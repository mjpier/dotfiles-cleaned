#!/usr/bin/fish

function c
    if count $argv > /dev/null
	    gcc $argv -o main
    else
        echo "c - compile c files"
        echo "usage: c <c source>"
    end
end
function cin
    if count $argv > /dev/null
	    gcc $argv -o main -lm
    else
        echo "cin - compile c files as a linked lib"
        echo "usage: cin <c source>"
    end
end

function b
    if count $argv > /dev/null
        /usr/bin/$argv[1] $argv[2..-1]
    else
        echo "b - execute binary files directly"
        echo "usage: b <command name> [options]"
    end
end
function l
    if count $argv > /dev/null
        $argv | /usr/bin/less
    else
        set tmpver (less)
        if not string match -ri "[Mm]issing [Ff]ilename.*"
            echo "l - show output as less"
            echo "usage: l <command> [options]"
        end
    end
end

function tarc
    if count $argv > /dev/null
        /usr/bin/tar -czvf $argv[1] $argv[2..-1]
    else
        echo "tarc - compress folders into .tar.gz files"
        echo "usage: <name> <folder(s)>"
    end
end
function tard
    if count $argv > /dev/null
        /usr/bin/tar -zxvf $argv
    else
        echo "tard - decompress .tar.gz archives"
        echo "usage: tard <file>"
    end
end
function tars
    if count $argv > /dev/null
        /usr/bin/tar -tvf $argv
    else
        echo "tars - show the contents of a .tar.gz archive"
        echo "usage: tars <file>"
    end
end

funcsave c
funcsave cin
funcsave b
funcsave l
funcsave tarc
funcsave tard
funcsave tars
