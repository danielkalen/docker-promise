Promise = require('bluebird').config warnings:false, longStackTraces:false
extend = require 'extend'
got = require 'got'
DOCKER_SOCKET = process.env.DOCKER_SOCKET or '/var/run/docker.sock:'
DOCKER_SOCKET = "http://unix:#{DOCKER_SOCKET}"


exports.req = request = (path, options={})->
	path = path.slice(1) if path[0] is '/'
	options.json ?= true
	
	Promise.resolve()
		.then ()-> got("#{DOCKER_SOCKET}/#{path}", options)._promise
		.get 'body'

exports.streamReq = streamRequest = (path, options={})->
	path = path.slice(1) if path[0] is '/'
	got.stream("#{DOCKER_SOCKET}/#{path}", options)



## ==========================================================================
## containers
## ========================================================================== 
exports.containers = (options)-> request "/containers/json", options
exports.containerCreate = (options)-> request "/containers/create", options
exports.containerInspect = (id, options)-> request "/containers/#{id}/json", options
exports.containerStats = (id, options)-> request "/containers/#{id}/stats", extend({query:stream:false}, options)
exports.containerStatsStream = (id, options)-> streamRequest "/containers/#{id}/stats", options
exports.containerProcesses = (id, options)-> request "/containers/#{id}/top", options
exports.containerLogs = (id, options)-> streamRequest "/containers/#{id}/logs", extend({follow:true}, options)
exports.containerResize = (id, options)-> request "/containers/#{id}/resize", extend({method:'post'}, options)
exports.containerStart = (id, options)-> request "/containers/#{id}/start", extend({method:'post'}, options)
exports.containerStop = (id, options)-> request "/containers/#{id}/stop", extend({method:'post'}, options)
exports.containerRestart = (id, options)-> request "/containers/#{id}/restart", extend({method:'post'}, options)
exports.containerKill = (id, options)-> request "/containers/#{id}/kill", extend({method:'post'}, options)
exports.containerPause = (id, options)-> request "/containers/#{id}/pause", extend({method:'post'}, options)
exports.containerUnpause = (id, options)-> request "/containers/#{id}/unpause", extend({method:'post'}, options)
exports.containerUpdate = (id, options)-> request "/containers/#{id}/update", extend({method:'post'}, options)
exports.containerRename = (id, options)-> request "/containers/#{id}/rename", extend({method:'post'}, options)
exports.containerWait = (id, options)-> request "/containers/#{id}/wait", extend({method:'post'}, options)
exports.containerRemove = (id, options)-> request "/containers/#{id}", extend({method:'delete'}, options)


## ==========================================================================
## images
## ========================================================================== 
exports.images = (options)-> request "/images/json", options
exports.imageBuild = (options)-> request "/images/build", extend({method:'post'}, options)
exports.imageCreate = (options)-> request "/images/create", extend({method:'post'}, options)
exports.imageInspect = (name, options)-> request "/images/#{name}/json", options
exports.imageHistory = (name, options)-> request "/images/#{name}/history", options
exports.imagePush = (name, options)-> request "/images/#{name}/push", extend({method:'post'}, options)
exports.imageTag = (name, options)-> request "/images/#{name}/tag", extend({method:'post'}, options)
exports.imageRemove = (name, options)-> request "/images/#{name}", extend({method:'delete'}, options)
exports.imageSearch = (options)-> request "/images/search", options
exports.imagePrune = (options)-> request "/images/search", extend({method:'post'}, options)




