#!/usr/bin/python

"""Utility funcs"""

from __future__ import print_function

import argparse
import distutils.version
import ftplib
import locale
import logging
import os
import re
import subprocess
import sys
import time
import urlparse


dry_run = False


def cd(cat, pn):
	"""Change to the $CATAGORY/$PN subdir for this package"""
	path = os.path.join(os.path.dirname(os.path.dirname(
		os.path.realpath(__file__))), cat, pn)
	logging.info('processing %s', path)
	os.chdir(path)
	assert os.path.exists('metadata.xml')


def list_snaps(url, debug=False):
	"""Get a listing of all the snapshots for this package"""
	if debug:
		if os.path.exists('.listing'):
			return open('.listing').read().splitlines()
	o = urlparse.urlparse(url)
	logging.info('listing %s', url)
	ftp = ftplib.FTP(o.netloc)
	ftp.login()
	ftp.cwd(o.path)
	nlst = ftp.nlst()
	if debug:
		with open('.listing', 'w') as f:
			f.write('\n'.join(nlst))
	return nlst


ver_sort = lambda x: sorted(x, key=lambda v: distutils.version.LooseVersion(v))


def run(cmd, **kwargs):
	logging.info('running: %s', ' '.join(cmd))
	if not dry_run:
		subprocess.check_call(cmd, **kwargs)


def run_ebuild(ebuild, command):
	"""Run `ebuild |ebuild| |command|`"""
	env = os.environ.copy()
	env.update({
		'FEATURES': 'assume-digests -strict digest',
		'GENTOO_MIRRORS': ' ',
	})
	run(['ebuild', ebuild, command], env=env)


def git(args):
	"""Run `git |args|`"""
	run(['git'] + args)


def setup_logging(debug=False):
	"""Setup the logging module"""
	fmt = '%(asctime)s: %(levelname)-7s: '
	if debug:
		fmt += '%(filename)s:%(funcName)s: '
	fmt += '%(message)s'
	datefmt = '%a, %d %b %Y %H:%M:%S ' + time.tzname[0]

	level = logging.DEBUG if debug else logging.INFO

	handler = logging.StreamHandler(stream=sys.stdout)
	formatter = logging.Formatter(fmt, datefmt)
	handler.setFormatter(formatter)

	logger = logging.getLogger()
	logger.addHandler(handler)
	logger.setLevel(level)


def get_ver(ebuild):
	"""Given an ebuild name, return the version"""
	m = re.match(r'[a-z-]+-(([0-9]+\.?)+)(_alpha([0-9]+))?\.ebuild', ebuild)
	if not m:
		raise ValueError('could not parse %s' % ebuild)
	dots = m.group(1)
	stamp = m.group(4)
	return distutils.version.LooseVersion('%s-%s' % (dots, stamp))


def parse_args(argv):
	parser = argparse.ArgumentParser()
	parser.add_argument('-d', '--debug', default=False, action='store_true')
	parser.add_argument('-n', '--dry-run', default=False, action='store_true')
	return parser.parse_args(argv)


def common_main(argv, cat, pn):
	locale.setlocale(locale.LC_ALL, 'C')

	opts = parse_args(argv)
	global dry_run
	dry_run = opts.dry_run

	setup_logging(debug=opts.debug)
	logging.info('running %s', pn)
	cd(cat, pn)

	# Clean the paths.
	git(['reset', 'HEAD', '.'])
	git(['checkout', '-f', '.'])
	git(['clean', '-q', '-f', '.'])
	git(['status', '.'])

	return opts
