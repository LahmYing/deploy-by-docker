!function(e){"use strict";function i(i){this.$codeBlocks=e(i)}i.prototype={run:function(){var i=this;i.resize(),e(window).smartresize(function(){i.resize()})},resize:function(){this.$codeBlocks.each(function(){var i=e(this).find(".gutter"),t=e(this).find(".code"),n=t.width()-t.innerWidth(),n=e(this).outerWidth()-i.outerWidth()+n;t.css("width",n),t.children("pre").css("width",n)})}},e(document).ready(function(){e.fn.hasHorizontalScrollBar=function(){return this.get(0).scrollWidth>this.innerWidth()},new i("figure.highlight").run()})}(jQuery);