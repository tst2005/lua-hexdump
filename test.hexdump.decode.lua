local decode = require "hexdump.decode"

local data

-- echo hello world hello world | od -An -t x1 -v
data=[[
 68 65 6c 6c 6f 20 77 6f 72 6c 64 20 68 65 6c 6c
 6f 20 77 6f 72 6c 64 0a
]]

assert(decode(data)=="hello world hello world\n")


-- echo hello world hello world | od -Ax -t x1 -v
data=[[
000000 68 65 6c 6c 6f 20 77 6f 72 6c 64 20 68 65 6c 6c
000010 6f 20 77 6f 72 6c 64 0a
000018
]]

assert(decode(data)=="hello world hello world\n")


-- echo hello world hello world | hexdump -C -v
data=[[
00000000  68 65 6c 6c 6f 20 77 6f  72 6c 64 20 68 65 6c 6c  |hello world hell|
00000010  6f 20 77 6f 72 6c 64 0a                           |o world.|
00000018
]]

assert(decode(data)=="hello world hello world\n")


-- lua -e 'io.stdout:write("hello"..("\0"):rep(60).."world")' | hexdump -C -v
data=                                                       [================[
00000000  68 65 6c 6c 6f 00 00 00  00 00 00 00 00 00 00 00  |hello...........|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000040  00 77 6f 72 6c 64                                 |.world|
00000046
]================]

assert(decode(data)==("hello"..("\0"):rep(60).."world"))


-- lua -e 'for n=0,20 do io.stdout:write("]"..("="):rep(n).."]") end' | hexdump -C -v
do
local data =                                                [================[
00000000  5d 5d 5d 3d 5d 5d 3d 3d  5d 5d 3d 3d 3d 5d 5d 3d  |]]]=]]==]]===]]=|
00000010  3d 3d 3d 5d 5d 3d 3d 3d  3d 3d 5d 5d 3d 3d 3d 3d  |===]]=====]]====|
00000020  3d 3d 5d 5d 3d 3d 3d 3d  3d 3d 3d 5d 5d 3d 3d 3d  |==]]=======]]===|
00000030  3d 3d 3d 3d 3d 5d 5d 3d  3d 3d 3d 3d 3d 3d 3d 3d  |=====]]=========|
00000040  5d 5d 3d 3d 3d 3d 3d 3d  3d 3d 3d 3d 5d 5d 3d 3d  |]]==========]]==|
00000050  3d 3d 3d 3d 3d 3d 3d 3d  3d 5d 5d 3d 3d 3d 3d 3d  |=========]]=====|
00000060  3d 3d 3d 3d 3d 3d 3d 5d  5d 3d 3d 3d 3d 3d 3d 3d  |=======]]=======|
00000070  3d 3d 3d 3d 3d 3d 5d 5d  3d 3d 3d 3d 3d 3d 3d 3d  |======]]========|
00000080  3d 3d 3d 3d 3d 3d 5d 5d  3d 3d 3d 3d 3d 3d 3d 3d  |======]]========|
00000090  3d 3d 3d 3d 3d 3d 3d 5d  5d 3d 3d 3d 3d 3d 3d 3d  |=======]]=======|
000000a0  3d 3d 3d 3d 3d 3d 3d 3d  3d 5d 5d 3d 3d 3d 3d 3d  |=========]]=====|
000000b0  3d 3d 3d 3d 3d 3d 3d 3d  3d 3d 3d 3d 5d 5d 3d 3d  |============]]==|
000000c0  3d 3d 3d 3d 3d 3d 3d 3d  3d 3d 3d 3d 3d 3d 3d 3d  |================|
000000d0  5d 5d 3d 3d 3d 3d 3d 3d  3d 3d 3d 3d 3d 3d 3d 3d  |]]==============|
000000e0  3d 3d 3d 3d 3d 5d 5d 3d  3d 3d 3d 3d 3d 3d 3d 3d  |=====]]=========|
000000f0  3d 3d 3d 3d 3d 3d 3d 3d  3d 3d 3d 5d              |===========]|
000000fc
]================]

assert(decode(data)==(
	function()
		local r={}
		for n=0,20 do
			table.insert(r, "]"..("="):rep(n).."]")
		end
		return table.concat(r)
	end)()
)
end

if arg[1] == "-" then

	data = io.stdin:read("*a")
	io.stdout:write(decode(data))
else
	print("ok")
end

