from os import path, system
import logging
import sys
import argparse

PROJECT_NAME_PATTERN = 'PROJECT1NAME'
SDK_PATTERN = 'SDK1VERSION'

log = logging.getLogger(__name__)
out_hdlr = logging.StreamHandler(sys.stdout)
out_hdlr.setFormatter(logging.Formatter('%(asctime)s %(message)s'))
out_hdlr.setLevel(logging.INFO)
log.addHandler(out_hdlr)
log.setLevel(logging.INFO)

def fill_template(project_name, projects_path, sdk_version, interface):
	log.info('[*] Fill Project: {project_name}, Projects Directory: {projects_path}'.format(project_name=project_name, projects_path=projects_path))
        
        files_list = list()

        src_file = path.join(projects_path, project_name, 'cpp/main.c')
        application_file = path.join(projects_path, project_name, 'cpp/Application.mk')
        files_list += [src_file, application_file]

        if interface == 'gui':
                android_manifest = path.join(projects_path, project_name, 'AndroidManifest.xml')
                main_activity = path.join(projects_path, project_name, 'java/com/zenysec/PROJECT1NAME/MainActivity.java')
                secret_activity = path.join(projects_path, project_name, 'java/com/zenysec/PROJECT1NAME/SecretClass.java')
                temp_java_dir = path.join(projects_path, project_name, 'java/com/zenysec/PROJECT1NAME')
                java_dir = temp_java_dir.replace('PROJECT1NAME', project_name)
                files_list += [android_manifest, main_activity, secret_activity]

	for f in files_list:
		log.info('[*] Modifying {path}'.format(path=f))
		with open(f, 'r') as fd:
			content = fd.read()
		with open(f, 'w') as fd:
			fd.write(content.replace(PROJECT_NAME_PATTERN, project_name).replace(SDK_PATTERN, sdk_version))
	
        if interface == 'gui':
                log.info('[*] Moving {old} To {new}'.format(old=temp_java_dir, new=java_dir))
        	system('mv {old} {new}'.format(old=temp_java_dir, new=java_dir))
	
	log.info('[*] done!')
	

if __name__ == '__main__':
	parser = argparse.ArgumentParser(description='Fill Template Project')
	parser.add_argument('-n', '--name', help='Project Name', required=True, dest='project_name')	
	parser.add_argument('-p', '--projects-dir', help='Projects Directory', required=True, dest='projects_path')
	parser.add_argument('-v', '--version-sdk', help='Minimal SDK Version', required=True, dest='sdk_version')
	parser.add_argument('-i', '--interface', help='Graphical User Interface / Command-Line Interface', required=True, dest='interface')

	fill_template(**vars(parser.parse_args()))

