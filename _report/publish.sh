#!/bin/bash
set -o errexit -o nounset

publishGhPages(){
  rm -rf db-benchmark.gh-pages
  mkdir -p db-benchmark.gh-pages
  cd db-benchmark.gh-pages

  ## Set up Repo parameters
  git init > /dev/null
  git config user.name "rajeshkannane"
  git config user.email "rajeshkannan.e@gmail.com"

  ## Set gh token from local file
  GH_TOKEN="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"

  ## Reset gh-pages branch
  git remote add upstream "https://$GH_TOKEN@github.com/rajeshkannane/h2o_dbbenchmark.git" 2>err.txt
  git fetch -q upstream gh-pages 2>err.txt
  rm -f err.txt
  git checkout -q gh-pages
  git reset -q --hard "f2d1593f0e760f0526ce2d8759d16955f29e2c6b" 2>err.txt

  rm -f err.txt
  cp -r ../public/* ./
  git add -A
  git commit -q -m 'publish benchmark report' 2>err.txt
  cp ../time.csv .
  cp ../logs.csv .
  git add time.csv logs.csv 2>err.txt
  md5sum time.csv > time.csv.md5
  md5sum logs.csv > logs.csv.md5
  git add time.csv.md5 logs.csv.md5 2>err.txt
  gzip --keep time.csv
  gzip --keep logs.csv
  git add time.csv.gz logs.csv.gz 2>err.txt
  git commit -q -m 'publish benchmark timings and logs' 2>err.txt
  git push --force upstream gh-pages 2>err.txt
  
  cd ..
  
}

publishGhPages
