# frozen_string_literal: true

project_file = ARGV.fetch(0, "Flinky.xcodeproj/project.pbxproj")
package_path = ENV.fetch("SENTRY_PACKAGE_PATH", "")

abort "error: SENTRY_PACKAGE_PATH is required" if package_path.empty?
abort "error: SENTRY_PACKAGE_PATH must not contain newlines" if package_path.match?(/[\r\n]/)
abort "error: SENTRY_PACKAGE_PATH must not contain double quotes" if package_path.include?('"')
abort "error: SENTRY_PACKAGE_PATH must not contain */" if package_path.include?("*/")

package_id = "D410FC5E2F3C8ABD0028B18D"
remote_comment = "#{package_id} /* XCRemoteSwiftPackageReference \"sentry-cocoa\" */"
local_comment = "#{package_id} /* XCLocalSwiftPackageReference \"#{package_path}\" */"

def pbxproj_string(value)
  value.gsub("\\", "\\\\\\\\").gsub('"', '\"')
end

local_block = [
  "\t\t#{local_comment} = {",
  "\t\t\tisa = XCLocalSwiftPackageReference;",
  "\t\t\trelativePath = \"#{pbxproj_string(package_path)}\";",
  "\t\t\ttraits = (",
  "\t\t\t);",
  "\t\t};",
  "",
].join("\n")

contents = File.read(project_file)
original_contents = contents.dup

remote_object_pattern = /^\t\t#{Regexp.escape(remote_comment)} = \{\n(?:^\t\t\t.*\n|^\t\t\t\t.*\n)*^\t\t\};\n/
local_object_pattern = /^\t*#{Regexp.escape(package_id)} \/\* XCLocalSwiftPackageReference ".*?" \*\/ = \{\n(?:^\t*.*\n)*?^\t*\};\n/

if contents.match?(local_object_pattern)
  contents.sub!(local_object_pattern, local_block)
elsif contents.match?(remote_object_pattern)
  contents.sub!(remote_object_pattern, "")

  if contents.include?("/* Begin XCLocalSwiftPackageReference section */")
    contents.sub!("/* Begin XCLocalSwiftPackageReference section */\n", "/* Begin XCLocalSwiftPackageReference section */\n#{local_block}")
  else
    local_section = [
      "/* Begin XCLocalSwiftPackageReference section */",
      local_block.chomp,
      "/* End XCLocalSwiftPackageReference section */",
      "",
    ].join("\n")

    unless contents.sub!("/* Begin XCRemoteSwiftPackageReference section */\n", "#{local_section}/* Begin XCRemoteSwiftPackageReference section */\n")
      abort "error: XCRemoteSwiftPackageReference section not found in #{project_file}"
    end
  end
else
  abort "error: Sentry package reference not found in #{project_file}"
end

contents.gsub!(remote_comment, local_comment)
contents.gsub!(/#{Regexp.escape(package_id)} \/\* XCLocalSwiftPackageReference ".*?" \*\//, local_comment)

if contents == original_contents
  puts "Sentry package patch is already applied."
else
  File.write(project_file, contents)
end
