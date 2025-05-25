function parseGitChangeLine(str) {
  const rangeMatch = str.match(/^@@ -(\d+),(\d+) \+(\d+),(\d+) @@/);
  if (rangeMatch) {
    currentChange = {
      oldStart: parseInt(rangeMatch[1], 10),
      oldLines: parseInt(rangeMatch[2], 10),
      newStart: parseInt(rangeMatch[3], 10),
      newLines: parseInt(rangeMatch[4], 10),
    };
    return currentChange;
  }
}

function generatePatchLineTr(isDark) {
  const tr = document.createElement("tr");

  const td_lineNumber = document.createElement("td");
  const div_lineNumber = document.createElement("div");
  const td_lineContent = document.createElement("td");
  const div_lineContent = document.createElement("div");
  td_lineNumber.appendChild(div_lineNumber);
  td_lineContent.appendChild(div_lineContent);

  td_lineNumber.classList.add("td_linenum");
  td_lineContent.classList.add("td_lineContent");
  div_lineContent.classList.add("div_lineContent");
  if (isDark) {
    td_lineNumber.classList.add("dark");
    td_lineContent.classList.add("dark");
  }

  tr.appendChild(td_lineNumber);
  tr.appendChild(td_lineContent);

  return { tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent };
}

// @@ -138,28 +136,72 @@ extension ZLCommitInfoController
function generateFileLineTr(line, isDark) {
  const { tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent } =
    generatePatchLineTr(isDark);

  const result = parseGitChangeLine(line);
  const oldLineNumber = result.oldStart;
  const newLineNumber = result.newStart;

  div_lineContent.textContent = line;

  td_lineNumber.classList.add("patch");
  td_lineContent.classList.add("patch");

  return { tr, oldLineNumber, newLineNumber };
}

// +//    func requestDiscussionComment(isLoadNew: Bool) {
function generateAdditionTr(line, isDark, newLineNumber) {
  const { tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent } =
    generatePatchLineTr(isDark);

  div_lineNumber.textContent = newLineNumber.toString();

  div_lineContent.textContent = line;
  td_lineNumber.classList.add("add");
  td_lineContent.classList.add("add");

  const newNum = newLineNumber + 1;
  return { tr, newNum };
}

// -//    func requestCommitDiffInfo() {
function generateDeletionTr(line, isDark, oldLineNumber) {
  const { tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent } =
    generatePatchLineTr(isDark);

  div_lineNumber.textContent = oldLineNumber.toString();
  div_lineContent.textContent = line;
  td_lineNumber.classList.add("delete");
  td_lineContent.classList.add("delete");

  const newNum = oldLineNumber + 1;
  return { tr, newNum };
}

function generateNormalTr(line, isDark, oldLineNumber, newLineNumber) {
  const { tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent } =
    generatePatchLineTr(isDark);

  div_lineNumber.textContent = newLineNumber.toString();
  div_lineContent.textContent = line;

  const newNum1 = oldLineNumber + 1;
  const newNum2 = newLineNumber + 1;
  return { tr, newNum1, newNum2 };
}

function render(patchText, isDark) {
  const html = document.querySelector("html");
  if (isDark) {
    html.classList.add("dark");
  } else {
    html.classList.remove("dark");
  }

  const patch = document.querySelector(".git-patch");
  while (patch.firstChild) {
    patch.removeChild(patch.firstChild);
  }
  /// 移除所有的子元素

  const patchLines = patchText.split("\n");

  if (patchLines.length > 0) {
    const table = document.createElement("table");
    const tbody = document.createElement("tbody");
    patch.appendChild(table);
    table.appendChild(tbody);

    let currentOldLineNumber = 0;
    let currentNewLineNumber = 0;

    patchLines.forEach((line, index) => {
      if (
        line.startsWith("diff --git") ||
        line.startsWith("index") ||
        line.startsWith("--- a") ||
        line.startsWith("+++ b")
      ) {
        return;
      }

      if (line.startsWith("@@")) {
        const { tr, oldLineNumber, newLineNumber } = generateFileLineTr(
          line,
          isDark
        );
        tbody.appendChild(tr);
        currentOldLineNumber = oldLineNumber;
        currentNewLineNumber = newLineNumber;
      } else if (line.startsWith("+")) {
        const { tr, newNum } = generateAdditionTr(
          line,
          isDark,
          currentNewLineNumber
        );
        tbody.appendChild(tr);
        currentNewLineNumber = newNum;
      } else if (line.startsWith("-")) {
        const { tr, newNum } = generateDeletionTr(
          line,
          isDark,
          currentOldLineNumber
        );
        tbody.appendChild(tr);
        currentOldLineNumber = newNum;
      } else {
        const { tr, newNum1, newNum2 } = generateNormalTr(
          line,
          isDark,
          currentOldLineNumber,
          currentNewLineNumber
        );
        tbody.appendChild(tr);
        currentOldLineNumber = newNum1;
        currentNewLineNumber = newNum2;
      }
    });
  }
}

function renderImage(imagePath, isDark) {
  const html = document.querySelector("html");
  if (isDark) {
    html.classList.add("dark");
  } else {
    html.classList.remove("dark");
  }
  const patch = document.querySelector(".git-patch");
  while (patch.firstChild) {
    patch.removeChild(patch.firstChild);
  }

  const img = document.createElement("img");
  img.classList.add("img_binary");
  img.src = imagePath;
  patch.appendChild(img);
}

function renderBinary(isDark) {
  const html = document.querySelector("html");
  if (isDark) {
    html.classList.add("dark");
  } else {
    html.classList.remove("dark");
  }
  const patch = document.querySelector(".git-patch");
  while (patch.firstChild) {
    patch.removeChild(patch.firstChild);
  }

  const div = document.createElement("div");
  div.classList.add("div_binary");
  if (isDark) {
    div.classList.add("dark");
  }
  div.textContent = "Binary File";
  patch.appendChild(div);
}
