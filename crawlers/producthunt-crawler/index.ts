import got from "got";
import fs from "fs";

const API_URL = "https://www.producthunt.com/frontend/graphql";

const query = cursor => ({
  operationName: "Posts",
  variables: { year: null, includeLayout: false, cursor },
  query: `
    query Posts($year: Int, $cursor: String) {
      posts(first: 20, year: $year, after: $cursor) {
        edges {
          node {
            ...PostItem
          }
        }
        pageInfo {
          endCursor
          hasNextPage
        }
      }
    }

    fragment PostItem on Post {
      comments_count
      name
      shortened_url
      slug
      tagline
      ...PostVoteButton
    }

    fragment PostVoteButton on Post {
      featured_at
      updated_at
      ... on Votable {
        votes_count
      }
    }
  `,
});

(async () => {
  let results = [];

  let cursor: string = null;
  let i = 1;

  while (true) {
    process.stdout.write(`Running query ${i}... `);
    const result = await got(API_URL, { json: true, body: query(cursor) });
    process.stdout.write(`OK\n`);

    if (result.body.errors) {
      console.error("Errors:", result.body.errors);
      break;
    }

    if (!result.body.data.posts.pageInfo.hasNextPage) {
      break;
    }

    cursor = result.body.data.posts.pageInfo.endCursor;
    results = [...results, ...result.body.data.posts.edges.map(e => e.node)];
    i++;
  }

  fs.writeFileSync("results.json", JSON.stringify(results));
})();
