add_rules("mode.debug", "mode.release")

target("interpreter-testing")
	set_kind("binary")
	add_files("src/*.cpp")
	add_files("src/*.asm")

	set_toolset("as", "nasm")

	add_asflags("-f win64 -g", {force=true})

	add_defines("UNSAFE_OPTIMIZATIONS")

	add_includedirs("../../Libraries/fstd/include/")