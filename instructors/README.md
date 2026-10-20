# Instructor notes for docker introduction

## Naming conventions

Slides to present are named `slides-X.md`

Reference materials are named `notes-Y.md`

Files with suffix `*.html` are build outputs from the VSCode exension: MarkdownPDF by yzane

The process is to open the `.md` file, `right-click`, select `Markdown PDF: Export (html)`

Then make sure you fix all the path references.... replace `../` with `../../`, and **then** afterwards `./fig/` with `../fig/`

## Slides

The slides are built using [Marp](https://marp.app/).
We recommend exporting the slides to html and then using the html slides for presenting.

To convert the slides you can either install the marp cli:
```bash
npm install --global @marp-team/marp-cli
```
and render the slides:
```bash
marp --html instructors/slides/slides-0-intro.md -o instructors/build/slides-0-intro.html
```
or install the vs code extenstion and useit to export the slide deck as html slides.

## Teaching notes

### Extracting code from episodes

To extract code from the notes, you can use the `extract_code.py` script.

From the repository's base directory run:
```bash
python3 code/extract_episodes_code.py
```
and the script will update the files in `code/episodes/`

### Updating the teaching notes

Not a lot of automation here, unfortunately... use the changes as marked in git when you extract the code, and then update the notes in `instructors/teaching_notes/` accordingly.

## Rendering course materials during development

You can use the sandpaper docker container to serve the site locally while you edit the notes by running the following command in the top directory of the repository:
```bash
docker run -d --rm --name sandpaper -p 4321:4321 -v $PWD:/siteroot/ ghcr.io/uomresearchit/sandpaper:latest

```
Then you can view the site at http://localhost:4321
