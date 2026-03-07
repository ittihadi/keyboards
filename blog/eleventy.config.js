module.exports = function (eleventyConfig) {
  const markdownIt = require('markdown-it')
  const markdownItAttrs = require('markdown-it-attrs')
  const markdownItFigCaptions = require('markdown-it-image-figures')

  const markdownItOptions = {
    html: true,
    breaks: false, // Don't treat \n in paragraphs as <br>
    linkify: true
  }

  const figoptions = {
    figcaption: true,
    lazy: true,
    async: true
  }

  const markdownLib = markdownIt(markdownItOptions)
    .use(markdownItAttrs)
    .use(markdownItFigCaptions, figoptions)
  eleventyConfig.setLibrary('md', markdownLib)

  eleventyConfig.addPassthroughCopy("bundle.css");
  eleventyConfig.addWatchTarget("bundle.css");

  eleventyConfig.addPassthroughCopy({ "./public/images/**/*.webp": "./images/" });

  eleventyConfig.setNunjucksEnvironmentOptions({
    lstripBlocks: true,
    trimBlocks: true,
  })

  return {
    pathPrefix: "keyboards",
  };
};
