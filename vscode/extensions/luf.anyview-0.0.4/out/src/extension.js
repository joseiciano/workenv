'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
function activate(context) {
    let disposable = vscode.commands.registerCommand('extension.anyview', fileUri => {
        let uri;
        if (!fileUri) {
            let editor = vscode.window.activeTextEditor;
            if (!editor) {
                return;
            }
            let document = editor.document;
            if (!document) {
                return;
            }
            uri = document.uri;
            if (!uri) {
                return;
            }
        }
        else {
            uri = fileUri;
        }
        vscode.commands
            .executeCommand('vscode.previewHtml', uri, vscode.ViewColumn.Two, 'Preview')
            .then(() => { }, (error) => { vscode.window.showErrorMessage(error); });
    });
    context.subscriptions.push(disposable);
}
exports.activate = activate;
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map