Promise = require('bluebird').config warnings:false, longStackTraces:false
extend = require 'extend'
got = require 'got'
DOCKER_API = process.env.DOCKER_API or "unix:/var/run/docker.sock:"


exports.req = request = (path, options={})->
	path = path.slice(1) if path[0] is '/'
	options.json ?= true
	
	Promise.resolve()
		.then ()-> got("#{DOCKER_API}/#{path}", options)._promise
		.get 'body'

exports.streamReq = streamRequest = (path, options={})->
	path = path.slice(1) if path[0] is '/'
	got.stream("#{DOCKER_API}/#{path}", options)



## ==========================================================================
## containers
## ========================================================================== 
exports.containers = (options)-> request "/containers/json", options
exports.containerCreate = (options)-> request "/containers/create", options
exports.containerInspect = (id, options)-> request "/containers/#{id}/json", options
exports.containerStats = (id, options)-> request "/containers/#{id}/stats", extend({query:stream:false}, options)
exports.containerProcesses = (id, options)-> request "/containers/#{id}/top", options
exports.containerResize = (id, options)-> request "/containers/#{id}/resize", extend({method:'post'}, options)
exports.containerLogs = (id, options)-> request "/containers/#{id}/logs", extend(json:false, query:{stdout:true, stderr:true}, options)
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


## ==========================================================================
## streams
## ========================================================================== 
exports.events = (options, cb)->
	if typeof options is 'function'
		cb = options
		options = null
	
	streamRequest("/events", options)
		.on 'data', (chunk)-> if cb?
			data = try JSON.parse(chunk.toString())
			cb(data) if data

exports.stats = (target, options, cb)->
	if typeof options is 'function'
		cb = options
		options = null
	
	streamRequest("/containers/#{target}/stats", options)
		.on 'data', (chunk)-> if cb?
			data = try JSON.parse(chunk.toString())
			cb(data) if data

exports.logs = (target, options, cb)->
	if typeof options is 'function'
		cb = options
		options = null
	
	options = extend({query:{stdout:true, stderr:true, follow:true}}, options)
	streamRequest("/containers/#{target}/logs", options)
		.on 'data', (chunk)-> if cb?
			data = try chunk.toString()
			cb(data) if data


