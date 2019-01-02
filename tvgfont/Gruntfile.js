module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    mySketchToolPath: '/Applications/Sketch.app/Contents/Resources/sketchtool/bin/sketchtool',
    prjPath: '/Users/dengjinlong/Documents/8-tvguo/2-TVGuoiOSApp/Library/Iconic',
    shell: {
      lsDir: 'ls src/icons',
      exportSketchSvgIcons: {
        command: [
          'rm -rf tmp/src/icons/svg/*',
          '<%= mySketchToolPath %> export slices src/icons.sketch --output=tmp/src/icons/svg --formats=svg'
        ].join(' ; ')
      },
      generateCode: 'cd ..; ./Source/Iconizer.sh ./tvgfont/src/font/tvgicons.ttf; cd -',
      copyToPrj: {
        command: [
          'cp ../Source/IconDrawable.swift <%= prjPath %>',
          'cp ../Source/IconImageView.swift <%= prjPath %>',
          'cp ../Source/TvgIcon.swift <%= prjPath %>',
        ].join(' ; ')
      }
    },
    webfont: {
      compileIcons: {
        src: 'tmp/src/icons/svg/*.svg', // 從 sketch 匯出的 svg 來源
        dest: 'src/font', // 字型檔案匯出目的地
        destCss: 'src/stylesheets', // css 檔案匯出目的地
        options: {
          font: "tvgicons",
          styles: ['font', 'icon'], // 匯出的 css 要包含哪些 css 宣告
          //types: ['eot', 'ttf', 'woff', 'woff2', 'svg'], // 要匯出的字體格式
          types: ['ttf', 'svg'], // 要匯出的字體格式
          syntax: 'bootstrap', // 以 boostrap 風格命名, class name 會是 icon-myicon
          engine: 'node', // 字體轉換的引擎, 使用 node 轉換
          fontHeight: 96, // 在 sketch 裡面, 一個 slice 的大小為 96x96, 故設為 96
          descent: 12, // 字體下邊線高度
          destHtml: 'src/icons' // 範例 html 檔案匯出目的地
        }
      }
    }
  });

  // Load the plugin used in grunt
  grunt.loadNpmTasks('grunt-shell');
  grunt.loadNpmTasks('grunt-webfont');

  // Default task(s).
  grunt.registerTask('default', ['shell:lsDir']);
  grunt.registerTask('generate-icons', ['shell:exportSketchSvgIcons', 'webfont:compileIcons']);
  grunt.registerTask('release-icons', ['shell:exportSketchSvgIcons', 'webfont:compileIcons', 'shell:generateCode', 'shell:copyToPrj']);
};
