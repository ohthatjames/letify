'use babel';

import { CompositeDisposable } from 'atom';

export default {

  subscriptions: null,

  activate() {
    this.subscriptions = new CompositeDisposable();

    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'letify:convert': () => this.convert()
    }));
  },

  deactivate() {
    this.subscriptions.dispose();
  },

  convert() {
    let editor
    if (editor = atom.workspace.getActiveTextEditor()) {
      if(editor.hasMultipleCursors()) {
        console.log("Giving up, multiple cursors");
        return;
      }
      if(editor.getSelectedText().match(/\n/)) {
        console.log("Giving up, multiple lines");
        return;
      }
      let point = editor.getCursorBufferPosition();
      editor.selectLinesContainingCursors();
      let selection = editor.getSelectedText();
      let match = selection.match(/(\s*)(.*)=(.*)/);
      if(!match) {
        console.log("Giving up, no match on line");
        return
      }
      let letStatement = match[1] + 'let(:' + match[2].trim() + ') { ' + match[3].trim() + " }\n";
      editor.insertText(letStatement);
      editor.setCursorScreenPosition(point);
    }
  }

};
