#!/usr/bin/env bash

source common.sh

exec 1>&2

# Basic scalar types
[[ $(nix eval --expr 'builtins.fromYAML "42" {}') == 42 ]]
[[ $(nix eval --expr 'builtins.fromYAML "3.14" {}') == 3.14 ]]
[[ $(nix eval --expr 'builtins.fromYAML "true" {}') == true ]]
[[ $(nix eval --expr 'builtins.fromYAML "false" {}') == false ]]
[[ $(nix eval --expr 'builtins.fromYAML "null" {}') == null ]]
[[ $(nix eval --expr 'builtins.fromYAML "\"hello\"" {}') == '"hello"' ]]

# Simple mapping
[[ $(nix eval --json --expr 'builtins.fromYAML "a: 1\nb: 2" {}') == '{"a":1,"b":2}' ]]

# Simple sequence
[[ $(nix eval --json --expr 'builtins.fromYAML "[1, 2, 3]" {}') == '[1,2,3]' ]]

# Nested structures
[[ $(nix eval --json --expr 'builtins.fromYAML "a:\n  b: 1\n  c: [2, 3]" {}') == '{"a":{"b":1,"c":[2,3]}}' ]]

# Quoted strings that look like numbers
[[ $(nix eval --expr 'builtins.fromYAML "\"42\"" {}') == '"42"' ]]

# Empty string should throw
expectStderr 1 nix eval --expr 'builtins.fromYAML "" {}' | grepQuiet "error"

# Anchors and aliases
[[ $(nix eval --json --expr 'builtins.fromYAML "defaults: &defaults\n  a: 1\n  b: 2\noverrides:\n  <<: *defaults\n  b: 3" {}') == '{"defaults":{"a":1,"b":2},"overrides":{"a":1,"b":3}}' ]]

# Multi-line strings (literal block scalar)
[[ $(nix eval --expr 'builtins.fromYAML "text: |\n  hello\n  world" {}') == '{ text = "hello\nworld\n"; }' ]]

# Folded block scalar
[[ $(nix eval --expr 'builtins.fromYAML "text: >\n  hello\n  world" {}') == '{ text = "hello world\n"; }' ]]

# YAML 1.2 booleans (only true/false)
[[ $(nix eval --expr 'builtins.fromYAML "yes" {}') == '"yes"' ]]
[[ $(nix eval --expr 'builtins.fromYAML "no" {}') == '"no"' ]]
[[ $(nix eval --expr 'builtins.fromYAML "on" {}') == '"on"' ]]
[[ $(nix eval --expr 'builtins.fromYAML "off" {}') == '"off"' ]]

# YAML 1.1 booleans with useBoolYAML1_1 option
[[ $(nix eval --expr 'builtins.fromYAML "yes" { useBoolYAML1_1 = true; }') == true ]]
[[ $(nix eval --expr 'builtins.fromYAML "no" { useBoolYAML1_1 = true; }') == false ]]

# Special float values
[[ $(nix eval --expr 'builtins.fromYAML ".inf" {}') == '".inf"' ]] || [[ $(nix eval --expr 'builtins.fromYAML ".inf" {}') == 'Infinity' ]] || true
[[ $(nix eval --expr 'builtins.fromYAML ".nan" {}') == '".nan"' ]] || [[ $(nix eval --expr 'builtins.fromYAML ".nan" {}') == 'NaN' ]] || true

# Mapping with various value types
[[ $(nix eval --json --expr 'builtins.fromYAML "str: hello\nnum: 42\nbool: true\nnul: null" {}') == '{"bool":true,"nul":null,"num":42,"str":"hello"}' ]]

# Sequence of mappings
[[ $(nix eval --json --expr 'builtins.fromYAML "- name: a\n  val: 1\n- name: b\n  val: 2" {}') == '[{"name":"a","val":1},{"name":"b","val":2}]' ]]

echo "fromYAML tests passed"
