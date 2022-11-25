---
title: "Working With Go Is Not That Horrible"
date: 2022-09-28T00:44:00+07:00
draft: true
toc: true
images:
categories:
tags:
  - go
  - rant
---

=> (Y F)
=> (Y (Y F)) 

As you may have, or may have not known it, I have been working with Go
professionally for... around a year, I think. Recently, I have also finished
(kinda) a side project in Go. At first, I thought of working with Go as
something kind of torturous, but it reality, it is... not that horrible (or it
is still horrible, but dealing with Go's horrible points are... tolerable).

## Error Handling

Go's pattern in error handling seems verbose at first:

```go
value, err := doStuff()
if err != nil {
    return err
}

anotherValue, err := doAnotherStuff()
if err != nil {
    return err
}
```

But being explicit in error throwing and error handling makes the end result
coding... nicer. Go coders are "almost" forced to deal with the error somewhere,
and I think it is a good point to be appreciated.

```go
if err != nil {
    print("error happened")
    panic(err)
}

if errors.Is(err, ErrCustomDefinition) {
    print("a custom error happened")
    print("handle it here")
}
```

## Typing

My "first love", or first professional language, is Python, which is a
dynamic typed language, or a language where the type is not specified, and errors
are thrown at runtime, instead of compile time like static typed language. It
just feel... safe and secure when you work with Go. Not bringing up the logic of
the code here, you can often be confident that your code works right if it pass
the compiler.

Generics is another nicety of Go that was recently added, and truly... just
work.

```go
/* without generics */
// SumInts adds together the values of m.
func SumInts(m map[string]int64) int64 {
    var s int64
    for _, v := range m {
        s += v
    }
    return s
}

// SumFloats adds together the values of m.
func SumFloats(m map[string]float64) float64 {
    var s float64
    for _, v := range m {
        s += v
    }
    return s
}


/* with generics */
// SumIntsOrFloats sums the values of map m. It supports both int64 and float64
// as types for map values.
func SumIntsOrFloats[K comparable, V int64 | float64](m map[K]V) V {
    var s V
    for _, v := range m {
        s += v
    }
    return s
}
```

Type aliasing in Go is also nice, where I can make my ideas clearer and having a
bit more constraints on the data.

```go
type AllowedValue int

type MyStruct {
    Field1 AllowedValue
    Field2 int
    Field3 string
}

const (
    AllowedValueOne = 1
    AllowedValueTwo = 2
)
```

My only complain is on mixing type aliases and generics. It just... does not
work (at least with function invoking; I did not test other cases).

```go
type MyStruct[T any] {
    Value T
}

func (r *MyStruct[T]) Print() {
    print(r.Value)
}

type Alias MyStruct[int]

a := Alias(MyStruct[int](Value: 3))
a.Print() // will not compile
```

## Package Manager and Binary Distribution

I was not sure how to write the part, but again, coming from Python's world,
being able to build your code into one "tiny" binary file feel nice. `go.mod`,
and `go.sum` also feel much nicer than the scenery of `requirements.txt` in
Python's world, and the myriad of package manager tools (Poetry, Piptools,
etc.). Where `pipx` is a tool to be installed, Go has you covered with `go
install ...@latest`, which feel really nice.

