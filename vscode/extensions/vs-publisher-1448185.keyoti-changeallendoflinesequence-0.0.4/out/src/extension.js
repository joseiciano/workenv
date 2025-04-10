/*---------------------------------------------------------
 * Copyright (C) Keyoti Inc. All rights reserved.
 *--------------------------------------------------------*/
'use strict';
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const path_1 = require("path");
function activate(context) {
    // Runs 'Change All End Of Line Sequence' on all files of specified type.
    vscode.commands.registerCommand('keyoti/changealleol', function () {
        return __awaiter(this, void 0, void 0, function* () {
            function convertLineEndingsInFilesInFolder(folder, fileTypeArray, newEnding, blackList, whiteList) {
                return __awaiter(this, void 0, void 0, function* () {
                    let count = 0;
                    for (const [name, type] of yield vscode.workspace.fs.readDirectory(folder)) {
                        if (type === vscode.FileType.File
                            && !blackList.includes(name)
                            && (!whiteList.length || whiteList.includes(name))
                            && fileTypeArray.filter((el) => { return name.endsWith(el); }).length > 0) {
                            const filePath = path_1.posix.join(folder.path, name);
                            var doc = yield vscode.workspace.openTextDocument(filePath);
                            yield vscode.window.showTextDocument(doc);
                            if (vscode.window.activeTextEditor !== null) {
                                yield vscode.window.activeTextEditor.edit(builder => {
                                    if (newEnding === "LF") {
                                        builder.setEndOfLine(vscode.EndOfLine.LF);
                                    }
                                    else {
                                        builder.setEndOfLine(vscode.EndOfLine.CRLF);
                                    }
                                    count++;
                                });
                            }
                            else {
                                vscode.window.showInformationMessage(doc.uri.toString());
                            }
                        }
                        if (type === vscode.FileType.Directory
                            && !blackList.includes(name)
                            && (!whiteList.length || whiteList.includes(name))
                            && !name.startsWith(".")) {
                            let newWhiteList = whiteList.includes(name) ? [] : [...whiteList];
                            count += (yield convertLineEndingsInFilesInFolder(vscode.Uri.file(path_1.posix.join(folder.path, name)), fileTypeArray, newEnding, blackList, newWhiteList)).count;
                        }
                    }
                    return { count };
                });
            }
            let options = { prompt: "File types to convert", placeHolder: ".cs, .txt", ignoreFocusOut: true };
            let fileTypes = yield vscode.window.showInputBox(options);
            let blackWhiteOptions = { prompt: "Add file/dir names for whitelist or blacklist (prefix with a !) (optional)", placeHolder: "!node_modules, src (no wildcards)", ignoreFocusOut: true };
            let blackWhite = (yield vscode.window.showInputBox(blackWhiteOptions)).split(/[ ,]+/);
            fileTypes = fileTypes.replace(' ', '');
            let fileTypeArray = [];
            let whiteList = [];
            let blackList = [];
            for (let x of blackWhite) {
                if (x[0] === '!') {
                    blackList.push(x.substring(1));
                }
                else if (x.length > 0) {
                    whiteList.push(x);
                }
            }
            let newEnding = yield vscode.window.showQuickPick(["LF", "CRLF"]);
            if (fileTypes !== null && newEnding !== null) {
                fileTypeArray = fileTypes.split(/[ ,]+/);
                if (vscode.workspace.workspaceFolders !== null && vscode.workspace.workspaceFolders.length > 0) {
                    const folderUri = vscode.workspace.workspaceFolders[0].uri;
                    const info = yield convertLineEndingsInFilesInFolder(folderUri, fileTypeArray, newEnding, blackList, whiteList);
                    if (info !== null) {
                        vscode.window.showInformationMessage(info.count + " files converted");
                    }
                }
            }
        });
    });
}
exports.activate = activate;
//# sourceMappingURL=extension.js.map