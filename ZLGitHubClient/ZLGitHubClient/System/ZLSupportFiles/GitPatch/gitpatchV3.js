

function parseDiffFilePath(line) {
  // 示例输入: diff --git a/path/to/file b/path/to/file
  const paths = line.split(" ");
  if (paths.length >= 3) {
    return paths[3].substring(2) // 去掉开头的 'b/'
  }
  return "";
}

function generateFilePath(line,isDark) {

    const fileDiv = document.createElement("div");
    fileDiv.classList.add("file");

    const filePath = parseDiffFilePath(line);
    const filePathDiv = document.createElement("div");
    filePathDiv.classList.add("filePath");
    if(isDark){
       filePathDiv.classList.add("dark"); 
    }
    filePathDiv.textContent = filePath;

    const table = document.createElement("table");
    const tbody = document.createElement("tbody");
    table.appendChild(tbody);

    fileDiv.appendChild(filePathDiv);
    fileDiv.appendChild(table);

    return {fileDiv, tbody}
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

    return {tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent};
}

// @@ -138,28 +136,72 @@ extension ZLCommitInfoController
function generateFileLineTr(line, isDark) {
    const { tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent} = generatePatchLineTr(isDark);

     const result = parseGitChangeLine(line);
     const oldLineNumber = result.oldStart 
     const newLineNumber = result.newStart

     div_lineContent.textContent = line;

     td_lineNumber.classList.add("patch");
     td_lineContent.classList.add("patch");

     return {tr, oldLineNumber, newLineNumber}
}

// +//    func requestDiscussionComment(isLoadNew: Bool) {
function generateAdditionTr(line, isDark, newLineNumber) {
    const { tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent} = generatePatchLineTr(isDark);

    div_lineNumber.textContent = newLineNumber.toString();

    div_lineContent.textContent = line;
    td_lineNumber.classList.add("add");
    td_lineContent.classList.add("add");

    const newNum = newLineNumber + 1;
    return { tr, newNum };
}

// -//    func requestCommitDiffInfo() {
function generateDeletionTr(line, isDark, oldLineNumber) {
    const { tr, td_lineNumber, td_lineContent, div_lineNumber, div_lineContent} = generatePatchLineTr(isDark);

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
        patch.removeChild(patch.firstChild);     /// 清除所有的子元素
    }

    const patchLines = patchText.split("\n");
    if (patchLines.length > 0) {

        let currenttbody = undefined;
        let currentOldLineNumber = 0;
        let currentNewLineNumber = 0;

        patchLines.forEach((line, index) => {
            if (
              line.startsWith("---") ||
              line.startsWith("+++") ||
              line.startsWith("new file mode") ||
              line.startsWith("deleted file mode") ||
              line.startsWith("Binary files") ||
              line.startsWith("index")
            ) {
              return;
            }

            if(line.startsWith("diff --git"))  {
                const {fileDiv,  tbody } = generateFilePath(line, isDark);
                currenttbody = tbody;
                patch.appendChild(fileDiv)
            } else if (line.startsWith("@@")) { 
                const { tr, oldLineNumber, newLineNumber } = generateFileLineTr(line, isDark);
                currenttbody.appendChild(tr);
                currentOldLineNumber = oldLineNumber
                currentNewLineNumber = newLineNumber
            } else if (line.startsWith("+")) { 
                const { tr, newNum } = generateAdditionTr(line, isDark, currentNewLineNumber);
                currenttbody.appendChild(tr);
                currentNewLineNumber = newNum;
            } else if (line.startsWith("-")) {
                const { tr, newNum } = generateDeletionTr(line, isDark, currentOldLineNumber);
                currenttbody.appendChild(tr); 
                currentOldLineNumber = newNum;
            } else if (line.startsWith(" ")) {
              const { tr, newNum1, newNum2 } = generateNormalTr(
                line,
                isDark,
                currentOldLineNumber,
                currentNewLineNumber
              );
              currenttbody.appendChild(tr);
              currentOldLineNumber = newNum1;
              currentNewLineNumber = newNum2;
            }
        });
    }
}


