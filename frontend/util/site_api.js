export const fetchSites = (success, error) => {
  $.ajax({
    method: 'get',
    url: 'api/sites',
    success,
    error
  });
};

export const fetchSite = (siteId, success, error) => {
  $.ajax({
    method: 'get',
    url: `api/sites/${siteId}`,
    success,
    error
  });
};

export const createSite = (site, success, error) => {
  $.ajax({
    method: 'post',
    url: 'api/sites',
    data: {site: site},
    success,
    error
  });
};