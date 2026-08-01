import os
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

# --- PDF (latexpdf) output -------------------------------------------------
# xelatex (not pdflatex) because the docs use Unicode arrows/checkmarks
# (->, <->, Y/N) throughout. DejaVu fonts give broad Unicode coverage, but
# pictographic emoji (setup, phone, camera, etc.) still won't render as
# color glyphs in the PDF -- that needs a dedicated emoji font/package this
# repo doesn't pull in. They'll likely show as blank boxes; harmless, just
# cosmetic.
latex_engine = "xelatex"
latex_elements = {
    "papersize": "a4paper",
    "pointsize": "11pt",
    "fontpkg": r"""
\setmainfont{DejaVu Serif}
\setsansfont{DejaVu Sans}
\setmonofont{DejaVu Sans Mono}
""",
}
latex_documents = [
    ("index", "bash-miscellaneous.tex", "Bash Miscellaneous", "Karthik", "manual"),
]
