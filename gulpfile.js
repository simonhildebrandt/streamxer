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
var build_dir = './tmp/js';


gulp.task('coffee', function() {
  return gulp.src(coffee_files)
    .pipe(watch(coffee_files))
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest(build_dir))
});

gulp.task('sass', function(){
  gulp.src('./node_modules/react-select/scss/default.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(rename('react-select.css'))
    .pipe(gulp.dest('./app/assets/stylesheets/'));
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
      .pipe(source('bundle.js'))
      .pipe(notify("Rebundled."))
      .pipe(gulp.dest('./app/assets/javascripts'))
    ;
  }

  browserified.on('update', function() {
      gutil.log('Rebundling...');
      bundle();
      gutil.log('Done.');
  });

  return bundle();
});
