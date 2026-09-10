<?php

declare(strict_types=1);

require __DIR__ . '/../app/_moduleBlogPublicIndex.php';
?>
<!DOCTYPE html>
<html lang="<?= htmlspecialchars($lang, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8') ?>">

<head>
    <?php include_once __DIR__ . '/../includes/_globalHead.php' ?>
</head>

<body class="blog-index-page">
    <?php include_once __DIR__ . '/../includes/_globalBody.php' ?>
    <?php include __DIR__ . '/../includes/_nav.php' ?>

    <div id="smooth-wrapper">
        <div id="smooth-content">
            <?php
            $blogHeroContent = controller('moduleH1Type01', 0);
            echo controller('hero00', 0, [
                '{hero00-content}' => $blogHeroContent,
            ]);
            ?>

            <main>
                <?php
                $blogCatalogSearch = controller('moduleBlogSearch01', 0, [
                    'id_prefix' => 'blog-index-search',
                    'action' => $blogIndex->basePath(),
                    'target_id' => 'blog-results',
                    'query' => $blogIndex->search() ?? '',
                    'order' => $blogIndex->order(),
                    'selected_categories' => $blogIndex->categories(),
                    'category_mode' => $blogIndex->categoryMode(),
                    'labels' => $blogIndex->searchLabels(),
                ]);

                $blogCatalogCategories = controller(
                    'moduleBlogCategoryBar01',
                    0,
                    [
                        'id_prefix' => 'blog-index-categories',
                        'action' => $blogIndex->basePath(),
                        'target_id' => 'blog-results',
                        'query' => $blogIndex->search() ?? '',
                        'order' => $blogIndex->order(),
                        'filters' => $blogIndex->filters(),
                        'selected_categories' => $blogIndex->categories(),
                        'category_mode' => $blogIndex->categoryMode(),
                        'labels' => $blogIndex->categoryLabels(),
                    ]
                );

                $blogResultsCollection = controller('moduleBlogGrid02', 0, [
                    'items_data' => $blogIndex->cards(),
                    'items' => $blogIndex->cardCount(),
                    'id_prefix' => 'blog-index-grid',
                    'layout' => 'regular',
                    'pagination_mode' => 'external',
                    'empty_message' => $blogIndex->emptyMessage(),
                    'cta_label' => $blogIndex->cardCtaLabel(),
                    'header_level' => 2,
                ]);

                $blogResultsPagination = controller(
                    'moduleBlogPagination01',
                    0,
                    [
                        'id_prefix' => 'blog-index-pagination',
                        'pages_data' => $blogIndex->paginationPages(),
                        'previous_url' => $blogIndex->previousUrl() ?? '',
                        'next_url' => $blogIndex->nextUrl() ?? '',
                        'labels' => $blogIndex->paginationLabels(),
                    ]
                );

                $blogResultsArchive = controller('moduleBlogArchive01', 0, [
                    'id_prefix' => 'blog-index-archive',
                    'periods_data' => $blogIndex->archivePeriods(),
                    'items' => $blogIndex->archiveCount(),
                    'header_level' => 3,
                    'header_text' => $blogIndex->archiveHeading(),
                    'header_lang' => 'blog_index_archive_heading',
                    'count_label_singular' =>
                        $blogIndex->archiveSingularLabel(),
                    'count_label_plural' =>
                        $blogIndex->archivePluralLabel(),
                ]);

                $blogResults = controller('moduleBlogResults01', 0, [
                    '{results-slot}' => $blogResultsCollection,
                    '{pagination-slot}' => $blogResultsPagination,
                    '{archive-slot}' => $blogResultsArchive,
                ]);

                echo controller('sectionBlogCatalog01', 0, [
                    'header_level' => 2,
                    'header_text' => $blogIndex->resultsHeading(),
                    'header_lang' => 'blog_index_results_heading',
                    '{search-slot}' => $blogCatalogSearch,
                    '{categories-slot}' => $blogCatalogCategories,
                    '{results-slot}' => $blogResults,
                ]);
                ?>
            </main>

            <?php include __DIR__ . '/../includes/_footer.php' ?>
        </div>
    </div>
</body>

</html>
