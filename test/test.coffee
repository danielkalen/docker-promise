Promise = require('bluebird').config warnings:false, longStackTraces:false
promiseBreak = require 'promise-break'
docker = require '../'
{expect} = require 'chai'

suite "docker-promise", ()->
	
	suite "methods", ()->
		suiteSetup ()->
			Promise.resolve()
				.then ()-> docker.containers()
				.then (res)=> @sample = res[0]
		
		test "containers", ()->
			Promise.resolve()
				.then ()-> docker.containers()
				.then (res)->
					expect(Array.isArray res).to.be.true
					if res.length
						expect(typeof res[0].Id).to.equal 'string'
		
		
		test "containerInspect", ()->
			@skip() if not @sample
			Promise.resolve()
				.then (res)=> docker.containerInspect(@sample.Id)
				.then (res)=>
					expect(typeof res).to.equal 'object'
					expect(typeof res.Created).to.equal 'string'
					expect(res.Id).to.equal @sample.Id

		

		test "containerStats", ()->
			@skip() if not @sample
			Promise.resolve()
				.then (res)=> docker.containerStats(@sample.Id)
				.then (res)->
					expect(typeof res).to.equal 'object'
					expect(typeof res.cpu_stats).to.equal 'object'
					expect(typeof res.read).to.equal 'string'

