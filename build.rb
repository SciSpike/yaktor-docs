#!/usr/bin/env ruby

require 'rubygems'
require 'asciidoctor'
require 'asciidoctor/cli/options'
require 'asciidoctor/cli/invoker'
require 'asciidoctor-diagram'
require 'fileutils'
require 'optparse'
require 'pathname'

out = "out"
src = "reference"
FileUtils.rm_rf(out)
FileUtils.mkdir_p(out + "/stylesheets")
FileUtils.cp_r(src + "/stylesheets",out)
Dir.glob(src+"/**/*.adoc") {
  |file|
  dest = Pathname.new(out+"/"+file)
  destDir = dest.dirname()
  relDest = (Pathname.new(out)).relative_path_from(destDir).to_s
  FileUtils.mkdir_p(destDir)
  arr = [
    "-D",destDir.to_s,
    "-a","source-highlighter=prettify",
    "-a","linkcss",
    "-a","stylesheet=" + relDest + "/stylesheets/yaktor.css",
    file ]
  Asciidoctor::Cli::Invoker.new(*arr).invoke!
}
