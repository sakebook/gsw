#!/usr/bin/env bats

setup() {
  # Mock gcloud command
  function gcloud() {
    echo "gcloud $*"
  }
  export -f gcloud

  # Source the script (assuming Zsh for now, but BATS runs in Bash usually. 
  # Since our script is currently Zsh-only, we might need to test strictly in Zsh 
  # or make the script compatible first.
  # HOWEVER, the current script is mostly POSIX compatible except for completion.
  # We will test the basic functions which SHOULD work in simple Bash unless zsh-specifics are hit.
  
  # To properly test Zsh functions, we usually need to run bats with Zsh or invoke zsh.
  # For simplicity in this initial "minimum" test, we will check if it source-able in Bash.
  # If it fails, that confirms we need the refactor! 
  
  # Actually, let's load it. The array syntax in _gsw might fail in Bash, 
  # but the functions gsw/gsw-local should be fine.
  source ./gsw.sh || true # Ignore errors specifically for the non-bash parts for now
}

@test "gsw-local sets CLOUDSDK_ACTIVE_CONFIG_NAME" {
  gsw-local "test-config"
  [ "$CLOUDSDK_ACTIVE_CONFIG_NAME" = "test-config" ]
}

@test "gsw activation calls gcloud config configurations activate" {
  # We need to mock the 'describe' call to succeed, otherwise gsw returns early.
  # Our mock just echoes, which counts as success (exit 0) and output.
  
  run gsw "test-config"
  [ "$status" -eq 0 ]
  # Check if it tried to activate
  [[ "$output" =~ "gcloud config configurations activate test-config" ]]
}

@test "gsw with no args shows usage" {
  run gsw
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage: gsw" ]]
}

@test "gsw --version outputs version" {
  run gsw --version
  [ "$status" -eq 0 ]
  # Check format: gsw version vX.X.X
  [[ "$output" =~ "gsw version v"[0-9]+\.[0-9]+\.[0-9]+ ]]
}

@test "gsw --help shows usage without config list" {
  run gsw --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage: gsw" ]]
  [[ "$output" =~ "--help" ]]
  # Should NOT call gcloud (no config list)
  [[ ! "$output" =~ "gcloud config configurations list" ]]
}

@test "gsw -h shows usage" {
  run gsw -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage: gsw" ]]
}

@test "gsw-local --help shows usage without config list" {
  run gsw-local --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage: gsw-local" ]]
  [[ "$output" =~ "--help" ]]
  # Should NOT call gcloud (no config list)
  [[ ! "$output" =~ "gcloud config configurations list" ]]
}

@test "gsw-local -h shows usage" {
  run gsw-local -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage: gsw-local" ]]
}
