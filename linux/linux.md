cat /etc/redhat-release  �鿴ϵͳ�汾��
����Linuxϵͳ������������������ʱ�����¼����ϵ�e�������ں˱༭����
��linux16�������е������׷�ӡ�rd.break��������Ȼ����Ctrl + X��ϼ��������޸Ĺ����ں˳���
mount -o remount,rw /sysroot
chroot /sysroot
passwd
touch /.autorelabel
exit
reboot


���õ�RPM����������
��װ�����������ʽ
rpm -ivh filename.rpm
���������������ʽ
rpm -Uvh filename.rpm
ж�������������ʽ
rpm -e filename.rpm
��ѯ����������Ϣ�������ʽ
rpm -qpi filename.rpm
�г������ļ���Ϣ�������ʽ
rpm -qpl filename.rpm
��ѯ�ļ������ĸ�RPM�������ʽ
rpm -qf filename


������Yum����

����
����
yum repolist all
�г����вֿ�
yum list all
�г��ֿ�������������
yum info ����������
�鿴��������Ϣ
yum install ����������
��װ������
yum reinstall ����������
���°�װ������
yum update ����������
����������
yum remove ����������
�Ƴ�������
yum clean all
������вֿ⻺��
yum check-update
���ɸ��µ�������
yum grouplist
�鿴ϵͳ���Ѿ���װ����������
yum groupinstall ��������
��װָ������������
yum groupremove ��������
�Ƴ�ָ������������
yum groupinfo ��������
��ѯָ��������������Ϣ

crt�����ϴ����ذ���װ
yum -y install lrzsz

which �ļ���

������������·��������

whereis ������

#������������·���������ĵ�����λ��

ѡ�

 -b :ֻ���ҿ�ִ���ļ�λ��

 -m:ֻ���Ұ����ļ�