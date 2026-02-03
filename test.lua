#!/usr/bin/env lua
-- Simple test runner for pather

local tests_run = 0
local tests_passed = 0

local function test(name, cmd, expected)
	tests_run = tests_run + 1
	local handle = io.popen(cmd .. " 2>&1")
	local result = handle:read("*a"):gsub("%s+$", "")
	handle:close()

	if result == expected then
		tests_passed = tests_passed + 1
		io.write(".")
	else
		io.write("F")
		print("\nFAIL: " .. name)
		print("  Expected: " .. expected)
		print("  Got:      " .. result)
	end
end

-- Tail tests
test("tail basic", "./pather -t /path/to/file.txt", "file.txt")
test("tail root", "./pather -t /etc", "etc")
test("tail no slash", "./pather -t file.txt", "file.txt")

-- Head tests
test("head basic", "./pather -h /path/to/file.txt", "/path/to")
test("head root", "./pather -h /etc", "/")
test("head no slash", "./pather -h file.txt", ".")

-- Extension tests
test("extension txt", "./pather -e file.txt", "txt")
test("extension tar.gz", "./pather -e file.tar.gz", "gz")
test("extension none", "./pather -e file", "")

-- Remove extension tests
test("remove ext txt", "./pather -r file.txt", "file")
test("remove ext tar.gz", "./pather -r file.tar.gz", "file.tar")
test("remove ext none", "./pather -r file", "file")

-- Absolute path with relative components
test("absolute with .", "./pather -a ./file.txt", os.getenv("PWD") .. "/file.txt")
test("absolute with ..", "./pather -a ../file.txt", os.getenv("PWD"):match("(.+)/[^/]+$") .. "/file.txt")
test("absolute with ././", "./pather -a ././file.txt", os.getenv("PWD") .. "/file.txt")
test("absolute with ../../", "./pather -a ../../file.txt", os.getenv("PWD"):match("(.+)/[^/]+/[^/]+$") .. "/file.txt")
test("absolute collapse ..", "./pather -a /foo/bar/../baz", "/foo/baz")
test("absolute multiple ..", "./pather -a /a/b/c/../../d", "/a/d")
test("absolute to root", "./pather -a /foo/..", "/")

-- Combined modifiers
test("head then tail", "./pather -ht /path/to/file.txt", "to")
test("head + head", "./pather -hh /path/to/file.txt", "/path")
test("tail + remove ext", "./pather -tr /path/to/file.txt", "file")

-- Multiple paths
test("multiple paths", "./pather -t /foo/bar.txt /baz/qux.sh", "bar.txt\nqux.sh")

print("\n" .. tests_passed .. "/" .. tests_run .. " tests passed")
os.exit(tests_passed == tests_run and 0 or 1)
