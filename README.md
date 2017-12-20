# Ix 2 Java
 Daniel Bradley @ ISLabs

## Introduction

Ix2Java is only intended to provide enough functionality to bootstrap the process of developing a fully functional Ix compiler in the Ix programming language.
As the Ix programming language shares some syntactic and semetic similarities with Java,
it is possible to easily convert between Ix source code and Java source code.
Thus this tool allows the development of a more advanced compiler written in Ix,
which will be converted to Java using this tool for compilation using the Java compiler,
resulting in a compiler that can compile Ix source code to C,
which will allow our Ix compiler to be converted to C and compiled using a C compiler.


## Implementation

The initital implementation of Ix2Java is implemented using Bash scripting and unix utilities.

```!bin/ix2java.sh
#!/bin/bash
```

### Usage

As Java classes can be compiled into class files individually,
this tool need only convert between a single Ix source file and a Java '.java' file.
The tools takes a single Ix source file as its sole command line argument,
and outputs the resulting Java source file to standard out.

```bin/ix2java.sh
function usage()
{
	echo "Usage: ix2java <ix source file>"
}
```

### Main

```bin/ix2java.sh
function main()
{
	local filepath=$1
	local filename=`basename "$filepath" .ix`

	local cpyrght=`extract_cpyrght "$filepath"`
	local license=`extract_license "$filepath"`
	local package=`extract_package "$filepath"`
	local imports=`extract_imports "$filepath"`
	local extends=`extract_extends "$filepath"`
	local members=`extract_members "$filepath"`
	local methods=`extract_methods "$filepath"`

	echo "${cpyrght}"
	echo "${license}"
	echo
	echo "${imports}"
	echo
	echo "class $filename $extends {"
	echo
	echo "$members"
	echo
	echo "$methods"
	echo
	echo "}"
}
```

#### Extract superclass

```bin/ix2java.sh
function extract_cpyrght()
{
	local copyright=`cat "$1" | grep "Copyright"`

	if [ -n "$copyright" ]
	then
		echo "/*"
		echo " *  $copyright"
		echo " */"
	fi
}
```

```bin/ix2java.sh
function extract_license()
{
	local license=`cat "$1" | grep "License"`

	if [ -n "$license" ]
	then
		echo "/*"
		echo " *  $license"
		echo " */"
	fi
}
```

```bin/ix2java.sh
function extract_package()
{
	local path=`dirname "$1"`
	local namespace=`basename "$path"`

	if [ -n "$namespace" ]
	then
		echo "package $namespace;"
	fi
}
```

```bin/ix2java.sh
function extract_imports()
{
	echo "import java.util.*;"
}
```

```bin/ix2java.sh
function extract_extends()
{
	local extends=`cat $1 | grep "extends" | sed 's/public//' | sed 's/class//' | sed 's/extends//' | sed 's/{//'`

	if [ -n "${extends}" ]
	then
		extends="extends ${extends}"
	fi

	echo $extends
}
```

```bin/ix2java.sh
function extract_members()
{
	local state="outside"

	while read -r line
	do
		if string_contains "$line" "class"
		then
			state="inside"

		elif string_contains "$line" "{"
		then
			continue

		elif string_contains "$line" "}"
		then
			break

		elif [ "$state" == "inside" ]
		then
			local name=`extract_word "$line" 1`
			local type=`extract_word "$line" 2`

			echo "$type $name;"
		fi
	done < $1
}
```

```bin/ix2java.sh
function extract_word()
{
	local line="$1"
	local word="$2"

	echo "$line" | sed "s/<TAB>//g" | sed 's/ //g' | sed 's/@//g' | sed 's/;//g' | cut -d : -f $word
}
```

```bin/ix2java.sh
function extract_methods()
{
	echo
}
```





## Common functions

```bin/ix2java.sh
function string_contains()
{
	local haystack="$1"
	local needle="$2"
	local tmp=`echo "$haystack" | sed "s|${needle}||g"`

	if [ -z "$haystack" ]
	then
		return 1 # false

	elif [ "$tmp" == "$haystack" ]
	then
		return 1 # false

	else
		return 0 # true
	fi
}

function string_containsx()
{
	local haystack="$1"
	local needle="$2"

	if [ -z "$haystack" ]
	then
		if [ -z "$needed" ]
		then
			return 0 # success
		else
			return 1 # failure
		fi

	elif [ -z "$needle" ]
	then
		return 0 # success

	elif [ -z "${haystack##*$needle*}" ]
	then
		return 0  # success

	else
		return -1 # failure

	fi
}
```

```bin/ix2java.sh
function string_starts_with()
{
    local haystack=$1
    local prefix=$2

    if [ "${haystack}" = "$prefix${haystack/$prefix}" ]
    then
        return 0  # success
    else
        return -1 # failure
    fi
}
```

```bin/ix2java.sh
function string_ends_with()
{
	local haystack=$1
	local suffix=$2

    if [ "${haystack}" = "${haystack/$suffix}${suffix}" ]
	then
		return 0  # success
	else
		return -1 # failure
	fi
}
```. Startup

If no parameters or multiple parameters are passed,
call usage and exit with a fail;
otherwise, call main and pass $1.

```bin/ix2java.sh
if [ "$#" != "1" ]
then
	usage
	exit -1
else
	main "$1"
fi
```
