import os
import shutil

project = "System Notes"
copyright = "2026, Karthik"
author = "Karthik"

extensions = [
    "sphinxcontrib.plantuml",
]

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

html_theme = "sphinx_rtd_theme"
html_static_path = ["_static"]
html_css_files = ["custom.css"]

# Debian/Ubuntu's "plantuml" apt package lags upstream by years and chokes
# on modern syntax (e.g. `!theme plain`), so CI downloads the current
# release jar itself (see .github/workflows/docs.yml) and points here via
# PLANTUML_JAR. Fall back to a `plantuml` binary on PATH, then a
# conventional local jar location, for anyone building this outside CI.
_plantuml_jar = os.environ.get("PLANTUML_JAR")
_plantuml_bin = shutil.which("plantuml")
if _plantuml_jar:
    plantuml = f"java -jar {_plantuml_jar}"
elif _plantuml_bin:
    plantuml = _plantuml_bin
else:
    plantuml = "java -jar /usr/share/plantuml/plantuml.jar"

plantuml_output_format = "svg_img"
