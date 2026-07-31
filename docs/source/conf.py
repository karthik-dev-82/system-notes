import shutil

project = "Bash Miscellaneous"
copyright = "2026, Karthik"
author = "Karthik"

extensions = [
    "sphinxcontrib.plantuml",
]

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

html_theme = "sphinx_rtd_theme"

# CI (see .github/workflows/docs.yml) installs the Debian/Ubuntu "plantuml"
# package, which provides a `plantuml` launcher script on PATH. Fall back to
# invoking the jar directly for local builds that only installed the jar.
_plantuml_bin = shutil.which("plantuml")
if _plantuml_bin:
    plantuml = _plantuml_bin
else:
    plantuml = "java -jar /usr/share/plantuml/plantuml.jar"

plantuml_output_format = "svg_img"
