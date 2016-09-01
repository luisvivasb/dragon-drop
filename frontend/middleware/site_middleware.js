import { receiveEntity, loadingEntity, removeEntity } from '../actions/entity_actions.js';
import * as ACTIONS from '../actions/site_actions.js';
import * as API from '../util/site_api.js';
import { arrayOfSites, site } from '../actions/schema.js';
import { normalize } from 'normalizr';
import { push } from 'react-router-redux';
import { createNotification } from '../actions/notification_actions.js';

const SiteMiddleware = ({ getState, dispatch }) => next => action => {
  switch (action.type) {
    case ACTIONS.REQUEST_SITES:
      dispatch(loadingEntity(true));
      API.fetchSites((sites) => {
        dispatch(receiveEntity(normalize(sites, arrayOfSites)));
      },
      err => {
        err.responseJSON.forEach(m => dispatch(createNotification('error', m)));
        dispatch(loadingEntity(false));
      }
      );
      return next(action);
    case ACTIONS.REQUEST_SITE:
    dispatch(loadingEntity(action.siteId));
      API.fetchSite(
        action.siteId,
        response => {
          dispatch(receiveEntity(normalize(response, site)));
        },
        err => {
          dispatch(push('/sites'))
          err.responseJSON.forEach(m => dispatch(createNotification('error', m)));
          dispatch(loadingEntity(false));
        }
      );
      return next(action);
    case ACTIONS.CREATE_SITE:
      API.createSite(
        action.site,
        response => {
          dispatch(receiveEntity(normalize(response, site)));
          dispatch(createNotification('success', 'Site successfully created!'));
        },
        err => {
          err.responseJSON.forEach(m => dispatch(createNotification('error', m)));
          dispatch(loadingEntity(false));
        }
      );
      return next(action);
    case ACTIONS.UPDATE_SITE:
      dispatch(loadingEntity(action.site.id));
      API.updateSite(
        action.site,
        response => {
          dispatch(receiveEntity(normalize(response, site)));
          dispatch(createNotification('success', 'Site successfully updated!'));
        },
        err => {
          err.responseJSON.forEach(m => dispatch(createNotification('error', m)));
          dispatch(loadingEntity(false));
        }
      );
      return next(action);
    case ACTIONS.DESTROY_SITE:
      dispatch(loadingEntity(action.site.id));
      API.destroySite(
        action.site,
        response => {
          dispatch(removeEntity(normalize(response, site)));
          dispatch(push('/sites'));
        },
        err => {
          err.responseJSON.forEach(m => dispatch(createNotification('error', m)));
          dispatch(loadingEntity(false));
        }
      );
      return next(action);
    default:
      return next(action);
  }
};

export default SiteMiddleware;
