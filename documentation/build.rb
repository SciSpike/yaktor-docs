#!/usr/bin/ruby
#sudo ARCHFLAGS="-Wno-error=unused-command-line-argument-hard-error-in-future" gem install asciidoctor-diagram
require 'rubygems'

require 'asciidoctor'
require 'asciidoctor/cli/options'
require 'asciidoctor/cli/invoker'
require 'asciidoctor-diagram'
require 'fileutils'
require 'optparse'
require 'pathname'

out = "build/docs"
src = "src/asciidoc"
FileUtils.rm_rf(out)
Dir.glob(src+"/**/*.png") {
  |file|
  sub = file.gsub(/src\/(.*)\/.*/, '\1').gsub(/asciidoc/,'')
  dest = out+sub
  FileUtils.mkdir_p(dest)
  FileUtils.cp(file,dest)
}
Dir.glob(src+"/**/*.adoc") {
  |file|
  sub = file.gsub(/src\/(.*)\/.*/, '\1').gsub(/asciidoc/,'')
  dest = out+sub
  relDest = ((Pathname.new out).relative_path_from Pathname.new(dest)).to_s
  FileUtils.mkdir_p(dest)
  FileUtils.cp("./docinfo.html",dest)
  arr = [
    "-D",dest,
    "-a","docinfo1",
    "-a","source-highlighter=prettify",
    "-a","toc2",
    "-a","idprefix=",
    "-a","idseparator=-",
    "-a","sectanchors",
    "-a","icons=font",
    "-a","linkcss",
    "-a","stylesheet=" + relDest + "/stylesheets/asciidoctor.css",
    file ]
  Asciidoctor::Cli::Invoker.new(*arr).invoke!
  FileUtils.rm(dest+"/docinfo.html")
}
FileUtils.mkdir_p(out + "/stylesheets")
FileUtils.cp_r("./src/stylesheets",out)
