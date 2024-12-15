package greenpizza

# Define the expected predicateSlugs
expected_predicate_slugs := {"cyclonedx-vex", "testing-results", "build-signature"}

# Collect all predicateSlugs found in the input JSON
found_predicate_slugs := {slug |
    some i, j
    slug := input.data.releaseBundleVersion.getVersion.artifactsConnection.edges[i].node.evidenceConnection.edges[j].node.predicateSlug
} | {slug |
    some k, l
    slug := input.data.releaseBundleVersion.getVersion.fromBuilds[k].evidenceConnection.edges[l].node.predicateSlug
} | {slug |
    some m
    slug := input.data.releaseBundleVersion.getVersion.evidenceConnection.edges[m].node.predicateSlug
}

found := [slug | slug := found_predicate_slugs[_]]
not_found := [slug | slug := expected_predicate_slugs[_]; not found_predicate_slugs[slug]]

# Check if all expected predicateSlugs are present
approved {
    count({slug | slug := expected_predicate_slugs[_]; slug != ""}) == count(found_predicate_slugs & expected_predicate_slugs)
}

output := {
    "found": found,
    "approved": approved,
    "not_found": not_found
}

# Provide a default output to ensure the rule always produces something
default approved = false

# Set the default rule to output the JSON
default output = {"found": [], "approved": false}
