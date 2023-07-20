function bump
    function app_name
        set -l mix_file $argv[1]
        set -l app_line (grep -m 1 -E "^\s*app: :[a-z_]+,\$" $mix_file)
        echo (string trim -c ':,' (string split ' ' (string trim $app_line))[2])
    end

    function current_version
        set -l mix_file $argv[1]
        set -l version_line (grep -m 1 -E "^\s*@version \"[0-9]+.[0-9]+.[0-9]\"\$" $mix_file)
        echo (string trim -c '"' (string split ' ' (string trim $version_line))[2])
    end

    function bump_version
        set -l major (string split '.' $argv[1])[1]
        set -l minor (string split '.' $argv[1])[2]
        set -l patch (string split '.' $argv[1])[3]

        switch $argv[2]
            case major
                set major (math $major + 1)
                set minor 0
                set patch 0
            case minor
                set minor (math $minor + 1)
                set patch 0
            case patch
                set patch (math $patch + 1)
        end

        echo "$major.$minor.$patch"
    end

    function update_changelog
        set -l changelog $argv[1]
        set -l new_version $argv[2]
        set -l today (date -u +'%Y-%m-%d')
        sed "s/## Unreleased/## Unreleased\n\n## [$new_version] - $today/g" $changelog >tmp && mv tmp $changelog
    end

    function update_mix_file
        set -l mix_file $argv[1]
        set -l new_version $argv[2]
        sed "s/@version \".*\"/@version \"$new_version\"/g" $mix_file >tmp && mv tmp $mix_file
    end

    function update_readme
        set -l readme $argv[1]
        set -l app $argv[2]
        set -l new_version $argv[3]
        sed "s/{:$app, \"~> [0-9]*\.[0-9]*\.[0-9]*\"}/{:$app, \"~> $new_version\"}/g" $readme >tmp && mv tmp $readme
    end

    set -l valid_args major minor patch

    if contains $argv[1] $valid_args
        set -l mix_file "mix.exs"
        set -l changelog "CHANGELOG.md"
        set -l readme "README.md"

        set -l app (app_name $mix_file)
        set -l curr_version (current_version $mix_file)
        set -l new_version (bump_version $curr_version $argv[1])

        echo "App: $app"
        echo "Current version: $curr_version"
        echo "New version: $new_version"

        update_changelog $changelog $new_version
        update_mix_file $mix_file $new_version
        update_readme $readme $app $new_version
    else
        echo "Usage: bump [major|minor|patch]"
    end
end
