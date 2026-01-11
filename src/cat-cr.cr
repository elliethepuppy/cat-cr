require "option_parser"

# TODO: Write documentation for `CatCr`
module CatCr
  VERSION = "0.1.1"

  # `parse_file` is the all-in-one checker. it takes in the *content : String* of
  # a file, along with all operational flags that `cat` normally takes, then
  # operates upon the *content* according to whether or not each flag is true.
  def self.parse_file(
    content : String,
    show_all : Bool,
    number_nonblank : Bool,
    show_nonprinting : Bool,
    show_ends : Bool,
    number_lines : Bool,
    squeeze_blank : Bool,
    show_tabs : Bool,
  )
    # if *number_nonblank* is true, numbers non-blank lines
    # (lines whose lengths are > 1) (need better way to check for "blank" chars)
    if number_nonblank
      new_content = String.new
      i = 1
      content.each_line do |line|
        if line.size < 2
          new_content += line
          i += 1
        else
          new_content += "#{i} #{line}"
          i += 1
        end
      end
      content = new_content
    end

    # if *number_lines* is true, numbers each line. need to implement caring
    # about the length of the number, but not sure how to just yet
    if number_lines
      new_content = ""
      i = 1
      content.each_line do |line|
        new_content += "#{i} #{line}"
      end
      content = new_content
    end

    # if *squeeze_blank* is true, allow for a maximum of two blank lines printed
    if squeeze_blank
      new_content = ""
      blank_line_counter = 0
      content.each_line do |line|
        if line.size < 2 && blank_line_counter >= 2
          next
        else
          new_content += "#{line}"
          blank_line_counter = 0
        end
      end
      content = new_content
    end

    # if *show_ends* is true, prints a "$" to visualize "\n"
    if show_ends
      content = content.gsub('\n', "$\n")
    end

    # if *show_tabs* is true, prints "^I" for each "\t"
    if show_tabs
      content = content.gsub('\t', "^I")
    end

    # if *show_nonprinting* is true, represents all nonprinting chars except
    # "\n" and "\t" with ^- or M- syntax. this is currently unimplemented.
    if show_nonprinting
      # TODO: implement this
    end

    # if *show_all* is true, represents all nonprinting chars with ^- or M-
    # syntax. Currently only supporting newlines and tabs.
    # TODO: implement all find-and-replaces for all special characters supported by GNU cat
    if show_all
      content = content.gsub('\n', "$\n")
      content = content.gsub('\t', "^I")
    end
    return content
  end
end

# set flags to defaults and initialize *files : Array(String)*
show_all = false
number_nonblank = false
show_nonprinting = false
show_ends = false
number_lines = false
squeeze_blank = false
show_tabs = false
files = [] of String
content = String.new

# create parser
parser = OptionParser.new do |parser|
  parser.banner = "cat - concatenate files and print on the standard output\n" \
                  "usage: cat [flags] [file(s)]"
  parser.on("-A", "--show-all", "print all nonprinting characters, except newline and TAB") { show_all = true }
  parser.on("-b", "--number-nonblank", "number each line that isn't blank") { number_nonblank = true }
  parser.on("-e", "equivalent to -v -E") { show_nonprinting = true; show_ends = true }
  parser.on("-E", "--show-ends", "display $ at the end of each line") { show_ends = true }
  parser.on("-n", "--number", "number all output lines") { number_lines = true }
  parser.on("-s", "--squeeze_blank", "suppress repeated empty output lines") { squeeze_blank = true }
  parser.on("-t", "show all nonprinting characters and TAB") { show_all = true; show_tabs = true }
  parser.on("-T", "--show-tabs", "display TAB characters as ^I") { show_tabs = true }
  parser.on("-h", "--help", "show this help") do
    puts parser
    exit 0
  end
  parser.on("-V", "--version", "show the version number") do
    puts CatCr::VERSION
    exit 0
  end

  # here is where each file name supplied is entered into *files*. the path is
  # automatically set to the cwd if no path is supplied. `~` is properly expanded
  # so that there's no issue of trying to find the literal "~" directory.
  parser.unknown_args do |unknowns|
    unknowns.each do |arg|
      if arg.starts_with?("./") || arg.starts_with?('/')
        files << arg
      elsif arg.starts_with?('~')
        files << Path[arg].expand(home: true).to_s
      elsif arg == "-"
        files << arg
      else
        files << "./#{arg}"
      end
    end
  end
end

# parse args
parser.parse

# if no args are passed, a repl takes input from `STDIN`, then prints it back
# out to `STDOUT`, with any formatting changes you specified with flags
# (the newline is added manually because `gets` automatically removes it).
# repl is exited with C-d, which sends `gets` a `nil` value. we check for this
# every loop, so there's never a chance of passing `nil` to `parse_file`.
# the program will always exit with a status code of 1 when it encounters `nil`
# in this mode.
if files.size < 1
  while true
    content = gets
    if content.nil?
      exit 0
    end
    output = CatCr.parse_file(content.not_nil!, show_all, number_nonblank, show_nonprinting, show_ends, number_lines, squeeze_blank, show_tabs) + "\n"
    puts output
  end
end

# if the files array is larger than 0, iterate over the members, either printing
# their contents, if a file, or taking input from `STDIN` and placing it back on
# `STDOUT` on "-". if the repl encounters a `nil` in this case, it simply breaks
# out of its loop and continues through the files.
files.each do |file|
  if file == "-"
    while true
      content = gets
      if content.nil?
        break
      end
      content = content + "\n"
      output = CatCr.parse_file(content.not_nil!, show_all, number_nonblank, show_nonprinting, show_ends, number_lines, squeeze_blank, show_tabs)
      puts output
    end
  else
    begin
      content = File.read(file)
    rescue File::NotFoundError
      STDERR.puts "#{file} could not be found!"
      STDERR.puts parser
      exit -1
    rescue IO::Error
      STDERR.puts "#{file} is not a file!"
      STDERR.puts parser
      exit -1
    end
    unless content.nil?
      output = CatCr.parse_file(content.not_nil!, show_all, number_nonblank, show_nonprinting, show_ends, number_lines, squeeze_blank, show_tabs)
      puts output
    end
  end
end
