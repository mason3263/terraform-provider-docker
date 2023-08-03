$location = "$(Get-Location)"
golangci-lint.exe run --out-format tab --path-prefix $location $args[0]