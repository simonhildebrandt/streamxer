'use strict';

var gulp = require('gulp');
var browserify = require('browserify');
var transform = require('vinyl-transform');
var debug = require('gulp-debug');
var coffeeify = require('coffeeify');
var coffee = require('gulp-coffee');
var gutil = require('gulp-util');
var source = require('vinyl-source-stream');
var watchify = require('watchify');
var watch = require('gulp-watch');
var buffer = require('vinyl-buffer');
var sass = require('gulp-sass');
var rename = require('gulp-rename');
var notify = require("gulp-notify");


var coffee_files = './app/assets/javascripts/**/*.coffee';
var styles_dir = './app/assets/stylesheets/';
var build_dir = './tmp/js';


gulp.task('coffee', function() {
  return gulp.src(coffee_files)
    .pipe(watch(coffee_files))
    .pipe(
      coffee({bare: true})
      .on('error', function(err) {
        gutil.log(err.toString());
        this.emit("end");
      })
    )
    .pipe(gulp.dest(build_dir))
});

gulp.task('sass', function(){
  gulp.src(styles_dir + 'index.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(rename('application.css'))
    .pipe(gulp.dest('./public'));
});

gulp.task('styles', function(){
  gulp.watch(styles_dir + '/*.scss',['sass']);
});

gulp.task('browserify', function () {

  var browserified = browserify({
    entries: build_dir + "/index.js",
    cache: {},
    packageCache: {},
    plugin: [watchify]
  });

  function bundle(){
    return browserified.bundle()
      .on('error', function (err) {
        gutil.log(err.toString());
        this.emit("end");
      })
      .pipe(source('application.js'))
      .pipe(notify("Rebundled."))
      .pipe(gulp.dest('./public'))
    ;
  }

  browserified.on('update', function() {
      gutil.log('Rebundling...');
      bundle();
      gutil.log('Done.');
  });

  return bundle();
});
