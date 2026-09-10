import '../scss/blog.scss';
import './_global.js';
import {
  initModuleBlogFilters01,
} from './resources/_moduleBlogFilters01.js';
import {
  initModuleBlogPagination01,
} from './resources/_moduleBlogPagination01.js';
import {
  initBlogCollectionLoader,
} from './modules/blog/blogCollectionLoader.js';
import {
  initModuleBlogGrid02,
} from './resources/_moduleBlogGrid02.js';
import { bindLanguageNavigation } from './resources/_languagePreference.mjs';

const unbindLanguageNavigation = bindLanguageNavigation(window, document);
const cleanupBlogGrid = initModuleBlogGrid02(document);
const cleanupBlogCollections = initBlogCollectionLoader(document);
const cleanupBlogFilters = initModuleBlogFilters01(document);
const cleanupBlogPagination = initModuleBlogPagination01(document);

if (import.meta.hot) {
  import.meta.hot.dispose(() => {
    cleanupBlogPagination();
    cleanupBlogFilters();
    cleanupBlogCollections();
    cleanupBlogGrid();
    unbindLanguageNavigation();
  });
}
