define([
  'jquery',
  'base/js/keyboard',
  'notebook/js/codecell',
  'notebook/js/completer',
  'nbextensions/vim_binding/vim_binding',
], function ($, keyboard, codecell, completer, vim_binding) {
  var undefined;
  var exports = {};
  var keycodes = keyboard.keycodes;
  var CodeCell = codecell.CodeCell;
  var Completer = completer.Completer;
  var OriginalCodeCell = undefined;
  var OriginalCompleter = undefined;

  function attachCodeCell() {
    if (OriginalCodeCell !== undefined) {
      return;
    }
    OriginalCodeCell = $.extend({}, CodeCell.prototype);
    CodeCell.prototype.handle_codemirror_keyevent = function handle_codemirror_keyevent(editor, event) {
      var code = event.keyCode;
      var ctrl = event.ctrlKey;
      if (this.completer.visible && event.type === 'keydown' && code == keycodes.tab) {
        return false;
      }
      return OriginalCodeCell.handle_codemirror_keyevent.apply(this, arguments);
    };
  }
  function attachCompleter() {
    if (OriginalCompleter !== undefined) {
      return;
    }
    OriginalCompleter = $.extend({}, Completer.prototype);
    Completer.prototype.keydown = function(event) {
      var code = event.keyCode;
      var ctrl = event.ctrlKey;
      var alternative;
      if (code === keycodes.tab) {
        alternative = {
          'key': event.shiftKey ? 'ArrowUp' : 'ArrowDown',
          'code': event.shiftKey ? keycodes.up : keycodes.down,
          'bubbles': true,
          'cancelable': true,
        };
      }
      if (alternative !== undefined) {
        if (alternative.code !== keycodes.tab) {
          // the following could not be called in orignal code while we create
          // a new keyboard event so call these at this point
          event.codemirrorIgnore = true;
          event._ipkmIgnore = true;
          event.preventDefault();
        }
        var monkeyPatchEvent = new KeyboardEvent(event.type, {
          'key': alternative.key,
          'code': alternative.key,
          'location': event.location,
          'bubbles': alternative.bubbles !== undefined ? event.bubbles : alternative.bubbles,
          'cancelable': alternative.cancelable !== undefined ? event.cancelable : alternative.cancelable,
          'ctrlKey': alternative.ctrlKey !== undefined ? event.ctrlKey : alternative.ctrlKey,
          'shiftKey': alternative.shiftKey !== undefined ? event.ctrlKey : alternative.ctrlKey,
          'altKey': alternative.altKey !== undefined ? event.altKey : alternative.altKey,
          'metaKey': alternative.metaKey !== undefined ? event.metaKey : alternative.metaKey,
          'repeat': event.repeat,
          'isComposing': event.isComposing,
          'composed': true,
          'charCode': alternative.key === '' ? 0 : alternative.key.charCodeAt(0),
        })
        // Source: https://stackoverflow.com/a/10520017
        Object.defineProperty(monkeyPatchEvent, 'keyCode', {
          get: function() {
            return alternative.code;
          }
        });
        Object.defineProperty(monkeyPatchEvent, 'which', {
          get: function() {
            return alternative.code;
          }
        });
        OriginalCompleter.keydown.call(this, monkeyPatchEvent);
      } else {
        OriginalCompleter.keydown.call(this, event);
      }
    };
  }

  vim_binding.on_ready_callbacks.push(function () {
    attachCodeCell();
    attachCompleter();
  });
});
