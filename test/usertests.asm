
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return randstate;
}

int
main(int argc, char *argv[])
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 e4 f0             	and    $0xfffffff0,%esp
       6:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
       9:	c7 44 24 04 b2 4e 00 	movl   $0x4eb2,0x4(%esp)
      10:	00 
      11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      18:	e8 83 3b 00 00       	call   3ba0 <printf>

  if(open("usertests.ran", 0) >= 0){
      1d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      24:	00 
      25:	c7 04 24 c6 4e 00 00 	movl   $0x4ec6,(%esp)
      2c:	e8 66 3a 00 00       	call   3a97 <open>
      31:	85 c0                	test   %eax,%eax
      33:	78 19                	js     4e <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
      35:	c7 44 24 04 30 56 00 	movl   $0x5630,0x4(%esp)
      3c:	00 
      3d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      44:	e8 57 3b 00 00       	call   3ba0 <printf>
    exit();
      49:	e8 09 3a 00 00       	call   3a57 <exit>
  }
  close(open("usertests.ran", O_CREATE));
      4e:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
      55:	00 
      56:	c7 04 24 c6 4e 00 00 	movl   $0x4ec6,(%esp)
      5d:	e8 35 3a 00 00       	call   3a97 <open>
      62:	89 04 24             	mov    %eax,(%esp)
      65:	e8 15 3a 00 00       	call   3a7f <close>

  argptest();
      6a:	e8 71 37 00 00       	call   37e0 <argptest>
  createdelete();
      6f:	e8 ac 11 00 00       	call   1220 <createdelete>
  linkunlink();
      74:	e8 8b 1a 00 00       	call   1b04 <linkunlink>
  concreate();
      79:	e8 aa 17 00 00       	call   1828 <concreate>
  fourfiles();
      7e:	e8 b1 0f 00 00       	call   1034 <fourfiles>
  sharedfd();
      83:	e8 dc 0d 00 00       	call   e64 <sharedfd>

  bigargtest();
      88:	e8 93 33 00 00       	call   3420 <bigargtest>
  bigwrite();
      8d:	e8 4e 24 00 00       	call   24e0 <bigwrite>
  bigargtest();
      92:	e8 89 33 00 00       	call   3420 <bigargtest>
  bsstest();
      97:	e8 14 33 00 00       	call   33b0 <bsstest>
  sbrktest();
      9c:	e8 13 2e 00 00       	call   2eb4 <sbrktest>
  validatetest();
      a1:	e8 62 32 00 00       	call   3308 <validatetest>

  opentest();
      a6:	e8 39 03 00 00       	call   3e4 <opentest>
  writetest();
      ab:	e8 d4 03 00 00       	call   484 <writetest>
  writetest1();
      b0:	e8 cf 05 00 00       	call   684 <writetest1>
  createtest();
      b5:	e8 aa 07 00 00       	call   864 <createtest>

  openiputtest();
      ba:	e8 25 02 00 00       	call   2e4 <openiputtest>
  exitiputtest();
      bf:	e8 3c 01 00 00       	call   200 <exitiputtest>
  iputtest();
      c4:	e8 57 00 00 00       	call   120 <iputtest>

  mem();
      c9:	e8 d6 0c 00 00       	call   da4 <mem>
  pipe1();
      ce:	e8 59 09 00 00       	call   a2c <pipe1>
  preempt();
      d3:	e8 fc 0a 00 00       	call   bd4 <preempt>
  exitwait();
      d8:	e8 43 0c 00 00       	call   d20 <exitwait>

  rmdot();
      dd:	e8 42 28 00 00       	call   2924 <rmdot>
  fourteen();
      e2:	e8 e5 26 00 00       	call   27cc <fourteen>
  bigfile();
      e7:	e8 ec 24 00 00       	call   25d8 <bigfile>
  subdir();
      ec:	e8 67 1c 00 00       	call   1d58 <subdir>
  linktest();
      f1:	e8 da 14 00 00       	call   15d0 <linktest>
  unlinkread();
      f6:	e8 05 13 00 00       	call   1400 <unlinkread>
  dirfile();
      fb:	e8 b4 29 00 00       	call   2ab4 <dirfile>
  iref();
     100:	e8 e3 2b 00 00       	call   2ce8 <iref>
  forktest();
     105:	e8 f2 2c 00 00       	call   2dfc <forktest>
  bigdir(); // slow
     10a:	e8 0d 1b 00 00       	call   1c1c <bigdir>

  uio();
     10f:	e8 4c 36 00 00       	call   3760 <uio>

  exectest();
     114:	e8 c3 08 00 00       	call   9dc <exectest>

  exit();
     119:	e8 39 39 00 00       	call   3a57 <exit>
     11e:	66 90                	xchg   %ax,%ax

00000120 <iputtest>:
{
     120:	55                   	push   %ebp
     121:	89 e5                	mov    %esp,%ebp
     123:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "iput test\n");
     126:	c7 44 24 04 58 3f 00 	movl   $0x3f58,0x4(%esp)
     12d:	00 
     12e:	a1 60 5f 00 00       	mov    0x5f60,%eax
     133:	89 04 24             	mov    %eax,(%esp)
     136:	e8 65 3a 00 00       	call   3ba0 <printf>
  if(mkdir("iputdir") < 0){
     13b:	c7 04 24 eb 3e 00 00 	movl   $0x3eeb,(%esp)
     142:	e8 78 39 00 00       	call   3abf <mkdir>
     147:	85 c0                	test   %eax,%eax
     149:	78 4b                	js     196 <iputtest+0x76>
  if(chdir("iputdir") < 0){
     14b:	c7 04 24 eb 3e 00 00 	movl   $0x3eeb,(%esp)
     152:	e8 70 39 00 00       	call   3ac7 <chdir>
     157:	85 c0                	test   %eax,%eax
     159:	0f 88 85 00 00 00    	js     1e4 <iputtest+0xc4>
  if(unlink("../iputdir") < 0){
     15f:	c7 04 24 e8 3e 00 00 	movl   $0x3ee8,(%esp)
     166:	e8 3c 39 00 00       	call   3aa7 <unlink>
     16b:	85 c0                	test   %eax,%eax
     16d:	78 5b                	js     1ca <iputtest+0xaa>
  if(chdir("/") < 0){
     16f:	c7 04 24 0d 3f 00 00 	movl   $0x3f0d,(%esp)
     176:	e8 4c 39 00 00       	call   3ac7 <chdir>
     17b:	85 c0                	test   %eax,%eax
     17d:	78 31                	js     1b0 <iputtest+0x90>
  printf(stdout, "iput test ok\n");
     17f:	c7 44 24 04 90 3f 00 	movl   $0x3f90,0x4(%esp)
     186:	00 
     187:	a1 60 5f 00 00       	mov    0x5f60,%eax
     18c:	89 04 24             	mov    %eax,(%esp)
     18f:	e8 0c 3a 00 00       	call   3ba0 <printf>
}
     194:	c9                   	leave  
     195:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     196:	c7 44 24 04 c4 3e 00 	movl   $0x3ec4,0x4(%esp)
     19d:	00 
     19e:	a1 60 5f 00 00       	mov    0x5f60,%eax
     1a3:	89 04 24             	mov    %eax,(%esp)
     1a6:	e8 f5 39 00 00       	call   3ba0 <printf>
    exit();
     1ab:	e8 a7 38 00 00       	call   3a57 <exit>
    printf(stdout, "chdir / failed\n");
     1b0:	c7 44 24 04 0f 3f 00 	movl   $0x3f0f,0x4(%esp)
     1b7:	00 
     1b8:	a1 60 5f 00 00       	mov    0x5f60,%eax
     1bd:	89 04 24             	mov    %eax,(%esp)
     1c0:	e8 db 39 00 00       	call   3ba0 <printf>
    exit();
     1c5:	e8 8d 38 00 00       	call   3a57 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
     1ca:	c7 44 24 04 f3 3e 00 	movl   $0x3ef3,0x4(%esp)
     1d1:	00 
     1d2:	a1 60 5f 00 00       	mov    0x5f60,%eax
     1d7:	89 04 24             	mov    %eax,(%esp)
     1da:	e8 c1 39 00 00       	call   3ba0 <printf>
    exit();
     1df:	e8 73 38 00 00       	call   3a57 <exit>
    printf(stdout, "chdir iputdir failed\n");
     1e4:	c7 44 24 04 d2 3e 00 	movl   $0x3ed2,0x4(%esp)
     1eb:	00 
     1ec:	a1 60 5f 00 00       	mov    0x5f60,%eax
     1f1:	89 04 24             	mov    %eax,(%esp)
     1f4:	e8 a7 39 00 00       	call   3ba0 <printf>
    exit();
     1f9:	e8 59 38 00 00       	call   3a57 <exit>
     1fe:	66 90                	xchg   %ax,%ax

00000200 <exitiputtest>:
{
     200:	55                   	push   %ebp
     201:	89 e5                	mov    %esp,%ebp
     203:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exitiput test\n");
     206:	c7 44 24 04 1f 3f 00 	movl   $0x3f1f,0x4(%esp)
     20d:	00 
     20e:	a1 60 5f 00 00       	mov    0x5f60,%eax
     213:	89 04 24             	mov    %eax,(%esp)
     216:	e8 85 39 00 00       	call   3ba0 <printf>
  pid = fork();
     21b:	e8 2f 38 00 00       	call   3a4f <fork>
  if(pid < 0){
     220:	83 f8 00             	cmp    $0x0,%eax
     223:	7c 71                	jl     296 <exitiputtest+0x96>
  if(pid == 0){
     225:	75 39                	jne    260 <exitiputtest+0x60>
    if(mkdir("iputdir") < 0){
     227:	c7 04 24 eb 3e 00 00 	movl   $0x3eeb,(%esp)
     22e:	e8 8c 38 00 00       	call   3abf <mkdir>
     233:	85 c0                	test   %eax,%eax
     235:	0f 88 8f 00 00 00    	js     2ca <exitiputtest+0xca>
    if(chdir("iputdir") < 0){
     23b:	c7 04 24 eb 3e 00 00 	movl   $0x3eeb,(%esp)
     242:	e8 80 38 00 00       	call   3ac7 <chdir>
     247:	85 c0                	test   %eax,%eax
     249:	78 65                	js     2b0 <exitiputtest+0xb0>
    if(unlink("../iputdir") < 0){
     24b:	c7 04 24 e8 3e 00 00 	movl   $0x3ee8,(%esp)
     252:	e8 50 38 00 00       	call   3aa7 <unlink>
     257:	85 c0                	test   %eax,%eax
     259:	78 21                	js     27c <exitiputtest+0x7c>
    exit();
     25b:	e8 f7 37 00 00       	call   3a57 <exit>
  wait();
     260:	e8 fa 37 00 00       	call   3a5f <wait>
  printf(stdout, "exitiput test ok\n");
     265:	c7 44 24 04 42 3f 00 	movl   $0x3f42,0x4(%esp)
     26c:	00 
     26d:	a1 60 5f 00 00       	mov    0x5f60,%eax
     272:	89 04 24             	mov    %eax,(%esp)
     275:	e8 26 39 00 00       	call   3ba0 <printf>
}
     27a:	c9                   	leave  
     27b:	c3                   	ret    
      printf(stdout, "unlink ../iputdir failed\n");
     27c:	c7 44 24 04 f3 3e 00 	movl   $0x3ef3,0x4(%esp)
     283:	00 
     284:	a1 60 5f 00 00       	mov    0x5f60,%eax
     289:	89 04 24             	mov    %eax,(%esp)
     28c:	e8 0f 39 00 00       	call   3ba0 <printf>
      exit();
     291:	e8 c1 37 00 00       	call   3a57 <exit>
    printf(stdout, "fork failed\n");
     296:	c7 44 24 04 05 4e 00 	movl   $0x4e05,0x4(%esp)
     29d:	00 
     29e:	a1 60 5f 00 00       	mov    0x5f60,%eax
     2a3:	89 04 24             	mov    %eax,(%esp)
     2a6:	e8 f5 38 00 00       	call   3ba0 <printf>
    exit();
     2ab:	e8 a7 37 00 00       	call   3a57 <exit>
      printf(stdout, "child chdir failed\n");
     2b0:	c7 44 24 04 2e 3f 00 	movl   $0x3f2e,0x4(%esp)
     2b7:	00 
     2b8:	a1 60 5f 00 00       	mov    0x5f60,%eax
     2bd:	89 04 24             	mov    %eax,(%esp)
     2c0:	e8 db 38 00 00       	call   3ba0 <printf>
      exit();
     2c5:	e8 8d 37 00 00       	call   3a57 <exit>
      printf(stdout, "mkdir failed\n");
     2ca:	c7 44 24 04 c4 3e 00 	movl   $0x3ec4,0x4(%esp)
     2d1:	00 
     2d2:	a1 60 5f 00 00       	mov    0x5f60,%eax
     2d7:	89 04 24             	mov    %eax,(%esp)
     2da:	e8 c1 38 00 00       	call   3ba0 <printf>
      exit();
     2df:	e8 73 37 00 00       	call   3a57 <exit>

000002e4 <openiputtest>:
{
     2e4:	55                   	push   %ebp
     2e5:	89 e5                	mov    %esp,%ebp
     2e7:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "openiput test\n");
     2ea:	c7 44 24 04 54 3f 00 	movl   $0x3f54,0x4(%esp)
     2f1:	00 
     2f2:	a1 60 5f 00 00       	mov    0x5f60,%eax
     2f7:	89 04 24             	mov    %eax,(%esp)
     2fa:	e8 a1 38 00 00       	call   3ba0 <printf>
  if(mkdir("oidir") < 0){
     2ff:	c7 04 24 63 3f 00 00 	movl   $0x3f63,(%esp)
     306:	e8 b4 37 00 00       	call   3abf <mkdir>
     30b:	85 c0                	test   %eax,%eax
     30d:	0f 88 9a 00 00 00    	js     3ad <openiputtest+0xc9>
  pid = fork();
     313:	e8 37 37 00 00       	call   3a4f <fork>
  if(pid < 0){
     318:	83 f8 00             	cmp    $0x0,%eax
     31b:	0f 8c a6 00 00 00    	jl     3c7 <openiputtest+0xe3>
  if(pid == 0){
     321:	75 35                	jne    358 <openiputtest+0x74>
    int fd = open("oidir", O_RDWR);
     323:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     32a:	00 
     32b:	c7 04 24 63 3f 00 00 	movl   $0x3f63,(%esp)
     332:	e8 60 37 00 00       	call   3a97 <open>
    if(fd >= 0){
     337:	85 c0                	test   %eax,%eax
     339:	78 6d                	js     3a8 <openiputtest+0xc4>
      printf(stdout, "open directory for write succeeded\n");
     33b:	c7 44 24 04 e8 4e 00 	movl   $0x4ee8,0x4(%esp)
     342:	00 
     343:	a1 60 5f 00 00       	mov    0x5f60,%eax
     348:	89 04 24             	mov    %eax,(%esp)
     34b:	e8 50 38 00 00       	call   3ba0 <printf>
      exit();
     350:	e8 02 37 00 00       	call   3a57 <exit>
     355:	8d 76 00             	lea    0x0(%esi),%esi
  sleep(1);
     358:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     35f:	e8 8b 37 00 00       	call   3aef <sleep>
  if(unlink("oidir") != 0){
     364:	c7 04 24 63 3f 00 00 	movl   $0x3f63,(%esp)
     36b:	e8 37 37 00 00       	call   3aa7 <unlink>
     370:	85 c0                	test   %eax,%eax
     372:	75 1c                	jne    390 <openiputtest+0xac>
  wait();
     374:	e8 e6 36 00 00       	call   3a5f <wait>
  printf(stdout, "openiput test ok\n");
     379:	c7 44 24 04 8c 3f 00 	movl   $0x3f8c,0x4(%esp)
     380:	00 
     381:	a1 60 5f 00 00       	mov    0x5f60,%eax
     386:	89 04 24             	mov    %eax,(%esp)
     389:	e8 12 38 00 00       	call   3ba0 <printf>
}
     38e:	c9                   	leave  
     38f:	c3                   	ret    
    printf(stdout, "unlink failed\n");
     390:	c7 44 24 04 7d 3f 00 	movl   $0x3f7d,0x4(%esp)
     397:	00 
     398:	a1 60 5f 00 00       	mov    0x5f60,%eax
     39d:	89 04 24             	mov    %eax,(%esp)
     3a0:	e8 fb 37 00 00       	call   3ba0 <printf>
     3a5:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
     3a8:	e8 aa 36 00 00       	call   3a57 <exit>
    printf(stdout, "mkdir oidir failed\n");
     3ad:	c7 44 24 04 69 3f 00 	movl   $0x3f69,0x4(%esp)
     3b4:	00 
     3b5:	a1 60 5f 00 00       	mov    0x5f60,%eax
     3ba:	89 04 24             	mov    %eax,(%esp)
     3bd:	e8 de 37 00 00       	call   3ba0 <printf>
    exit();
     3c2:	e8 90 36 00 00       	call   3a57 <exit>
    printf(stdout, "fork failed\n");
     3c7:	c7 44 24 04 05 4e 00 	movl   $0x4e05,0x4(%esp)
     3ce:	00 
     3cf:	a1 60 5f 00 00       	mov    0x5f60,%eax
     3d4:	89 04 24             	mov    %eax,(%esp)
     3d7:	e8 c4 37 00 00       	call   3ba0 <printf>
    exit();
     3dc:	e8 76 36 00 00       	call   3a57 <exit>
     3e1:	8d 76 00             	lea    0x0(%esi),%esi

000003e4 <opentest>:
{
     3e4:	55                   	push   %ebp
     3e5:	89 e5                	mov    %esp,%ebp
     3e7:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "open test\n");
     3ea:	c7 44 24 04 9e 3f 00 	movl   $0x3f9e,0x4(%esp)
     3f1:	00 
     3f2:	a1 60 5f 00 00       	mov    0x5f60,%eax
     3f7:	89 04 24             	mov    %eax,(%esp)
     3fa:	e8 a1 37 00 00       	call   3ba0 <printf>
  fd = open("echo", 0);
     3ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     406:	00 
     407:	c7 04 24 a9 3f 00 00 	movl   $0x3fa9,(%esp)
     40e:	e8 84 36 00 00       	call   3a97 <open>
  if(fd < 0){
     413:	85 c0                	test   %eax,%eax
     415:	78 37                	js     44e <opentest+0x6a>
  close(fd);
     417:	89 04 24             	mov    %eax,(%esp)
     41a:	e8 60 36 00 00       	call   3a7f <close>
  fd = open("doesnotexist", 0);
     41f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     426:	00 
     427:	c7 04 24 c1 3f 00 00 	movl   $0x3fc1,(%esp)
     42e:	e8 64 36 00 00       	call   3a97 <open>
  if(fd >= 0){
     433:	85 c0                	test   %eax,%eax
     435:	79 31                	jns    468 <opentest+0x84>
  printf(stdout, "open test ok\n");
     437:	c7 44 24 04 ec 3f 00 	movl   $0x3fec,0x4(%esp)
     43e:	00 
     43f:	a1 60 5f 00 00       	mov    0x5f60,%eax
     444:	89 04 24             	mov    %eax,(%esp)
     447:	e8 54 37 00 00       	call   3ba0 <printf>
}
     44c:	c9                   	leave  
     44d:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     44e:	c7 44 24 04 ae 3f 00 	movl   $0x3fae,0x4(%esp)
     455:	00 
     456:	a1 60 5f 00 00       	mov    0x5f60,%eax
     45b:	89 04 24             	mov    %eax,(%esp)
     45e:	e8 3d 37 00 00       	call   3ba0 <printf>
    exit();
     463:	e8 ef 35 00 00       	call   3a57 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     468:	c7 44 24 04 ce 3f 00 	movl   $0x3fce,0x4(%esp)
     46f:	00 
     470:	a1 60 5f 00 00       	mov    0x5f60,%eax
     475:	89 04 24             	mov    %eax,(%esp)
     478:	e8 23 37 00 00       	call   3ba0 <printf>
    exit();
     47d:	e8 d5 35 00 00       	call   3a57 <exit>
     482:	66 90                	xchg   %ax,%ax

00000484 <writetest>:
{
     484:	55                   	push   %ebp
     485:	89 e5                	mov    %esp,%ebp
     487:	56                   	push   %esi
     488:	53                   	push   %ebx
     489:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "small file test\n");
     48c:	c7 44 24 04 fa 3f 00 	movl   $0x3ffa,0x4(%esp)
     493:	00 
     494:	a1 60 5f 00 00       	mov    0x5f60,%eax
     499:	89 04 24             	mov    %eax,(%esp)
     49c:	e8 ff 36 00 00       	call   3ba0 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     4a1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     4a8:	00 
     4a9:	c7 04 24 0b 40 00 00 	movl   $0x400b,(%esp)
     4b0:	e8 e2 35 00 00       	call   3a97 <open>
     4b5:	89 c6                	mov    %eax,%esi
  if(fd >= 0){
     4b7:	85 c0                	test   %eax,%eax
     4b9:	0f 88 ab 01 00 00    	js     66a <writetest+0x1e6>
    printf(stdout, "creat small succeeded; ok\n");
     4bf:	c7 44 24 04 11 40 00 	movl   $0x4011,0x4(%esp)
     4c6:	00 
     4c7:	a1 60 5f 00 00       	mov    0x5f60,%eax
     4cc:	89 04 24             	mov    %eax,(%esp)
     4cf:	e8 cc 36 00 00       	call   3ba0 <printf>
  for(i = 0; i < 100; i++){
     4d4:	31 db                	xor    %ebx,%ebx
     4d6:	66 90                	xchg   %ax,%ax
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     4d8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     4df:	00 
     4e0:	c7 44 24 04 48 40 00 	movl   $0x4048,0x4(%esp)
     4e7:	00 
     4e8:	89 34 24             	mov    %esi,(%esp)
     4eb:	e8 87 35 00 00       	call   3a77 <write>
     4f0:	83 f8 0a             	cmp    $0xa,%eax
     4f3:	0f 85 e7 00 00 00    	jne    5e0 <writetest+0x15c>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     4f9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     500:	00 
     501:	c7 44 24 04 53 40 00 	movl   $0x4053,0x4(%esp)
     508:	00 
     509:	89 34 24             	mov    %esi,(%esp)
     50c:	e8 66 35 00 00       	call   3a77 <write>
     511:	83 f8 0a             	cmp    $0xa,%eax
     514:	0f 85 e4 00 00 00    	jne    5fe <writetest+0x17a>
  for(i = 0; i < 100; i++){
     51a:	43                   	inc    %ebx
     51b:	83 fb 64             	cmp    $0x64,%ebx
     51e:	75 b8                	jne    4d8 <writetest+0x54>
  printf(stdout, "writes ok\n");
     520:	c7 44 24 04 5e 40 00 	movl   $0x405e,0x4(%esp)
     527:	00 
     528:	a1 60 5f 00 00       	mov    0x5f60,%eax
     52d:	89 04 24             	mov    %eax,(%esp)
     530:	e8 6b 36 00 00       	call   3ba0 <printf>
  close(fd);
     535:	89 34 24             	mov    %esi,(%esp)
     538:	e8 42 35 00 00       	call   3a7f <close>
  fd = open("small", O_RDONLY);
     53d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     544:	00 
     545:	c7 04 24 0b 40 00 00 	movl   $0x400b,(%esp)
     54c:	e8 46 35 00 00       	call   3a97 <open>
     551:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     553:	85 c0                	test   %eax,%eax
     555:	0f 88 c1 00 00 00    	js     61c <writetest+0x198>
    printf(stdout, "open small succeeded ok\n");
     55b:	c7 44 24 04 69 40 00 	movl   $0x4069,0x4(%esp)
     562:	00 
     563:	a1 60 5f 00 00       	mov    0x5f60,%eax
     568:	89 04 24             	mov    %eax,(%esp)
     56b:	e8 30 36 00 00       	call   3ba0 <printf>
  i = read(fd, buf, 2000);
     570:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
     577:	00 
     578:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
     57f:	00 
     580:	89 1c 24             	mov    %ebx,(%esp)
     583:	e8 e7 34 00 00       	call   3a6f <read>
  if(i == 2000){
     588:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     58d:	0f 85 a3 00 00 00    	jne    636 <writetest+0x1b2>
    printf(stdout, "read succeeded ok\n");
     593:	c7 44 24 04 9d 40 00 	movl   $0x409d,0x4(%esp)
     59a:	00 
     59b:	a1 60 5f 00 00       	mov    0x5f60,%eax
     5a0:	89 04 24             	mov    %eax,(%esp)
     5a3:	e8 f8 35 00 00       	call   3ba0 <printf>
  close(fd);
     5a8:	89 1c 24             	mov    %ebx,(%esp)
     5ab:	e8 cf 34 00 00       	call   3a7f <close>
  if(unlink("small") < 0){
     5b0:	c7 04 24 0b 40 00 00 	movl   $0x400b,(%esp)
     5b7:	e8 eb 34 00 00       	call   3aa7 <unlink>
     5bc:	85 c0                	test   %eax,%eax
     5be:	0f 88 8c 00 00 00    	js     650 <writetest+0x1cc>
  printf(stdout, "small file test ok\n");
     5c4:	c7 44 24 04 c5 40 00 	movl   $0x40c5,0x4(%esp)
     5cb:	00 
     5cc:	a1 60 5f 00 00       	mov    0x5f60,%eax
     5d1:	89 04 24             	mov    %eax,(%esp)
     5d4:	e8 c7 35 00 00       	call   3ba0 <printf>
}
     5d9:	83 c4 10             	add    $0x10,%esp
     5dc:	5b                   	pop    %ebx
     5dd:	5e                   	pop    %esi
     5de:	5d                   	pop    %ebp
     5df:	c3                   	ret    
      printf(stdout, "error: write aa %d new file failed\n", i);
     5e0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     5e4:	c7 44 24 04 0c 4f 00 	movl   $0x4f0c,0x4(%esp)
     5eb:	00 
     5ec:	a1 60 5f 00 00       	mov    0x5f60,%eax
     5f1:	89 04 24             	mov    %eax,(%esp)
     5f4:	e8 a7 35 00 00       	call   3ba0 <printf>
      exit();
     5f9:	e8 59 34 00 00       	call   3a57 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     5fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     602:	c7 44 24 04 30 4f 00 	movl   $0x4f30,0x4(%esp)
     609:	00 
     60a:	a1 60 5f 00 00       	mov    0x5f60,%eax
     60f:	89 04 24             	mov    %eax,(%esp)
     612:	e8 89 35 00 00       	call   3ba0 <printf>
      exit();
     617:	e8 3b 34 00 00       	call   3a57 <exit>
    printf(stdout, "error: open small failed!\n");
     61c:	c7 44 24 04 82 40 00 	movl   $0x4082,0x4(%esp)
     623:	00 
     624:	a1 60 5f 00 00       	mov    0x5f60,%eax
     629:	89 04 24             	mov    %eax,(%esp)
     62c:	e8 6f 35 00 00       	call   3ba0 <printf>
    exit();
     631:	e8 21 34 00 00       	call   3a57 <exit>
    printf(stdout, "read failed\n");
     636:	c7 44 24 04 c9 43 00 	movl   $0x43c9,0x4(%esp)
     63d:	00 
     63e:	a1 60 5f 00 00       	mov    0x5f60,%eax
     643:	89 04 24             	mov    %eax,(%esp)
     646:	e8 55 35 00 00       	call   3ba0 <printf>
    exit();
     64b:	e8 07 34 00 00       	call   3a57 <exit>
    printf(stdout, "unlink small failed\n");
     650:	c7 44 24 04 b0 40 00 	movl   $0x40b0,0x4(%esp)
     657:	00 
     658:	a1 60 5f 00 00       	mov    0x5f60,%eax
     65d:	89 04 24             	mov    %eax,(%esp)
     660:	e8 3b 35 00 00       	call   3ba0 <printf>
    exit();
     665:	e8 ed 33 00 00       	call   3a57 <exit>
    printf(stdout, "error: creat small failed!\n");
     66a:	c7 44 24 04 2c 40 00 	movl   $0x402c,0x4(%esp)
     671:	00 
     672:	a1 60 5f 00 00       	mov    0x5f60,%eax
     677:	89 04 24             	mov    %eax,(%esp)
     67a:	e8 21 35 00 00       	call   3ba0 <printf>
    exit();
     67f:	e8 d3 33 00 00       	call   3a57 <exit>

00000684 <writetest1>:
{
     684:	55                   	push   %ebp
     685:	89 e5                	mov    %esp,%ebp
     687:	56                   	push   %esi
     688:	53                   	push   %ebx
     689:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "big files test\n");
     68c:	c7 44 24 04 d9 40 00 	movl   $0x40d9,0x4(%esp)
     693:	00 
     694:	a1 60 5f 00 00       	mov    0x5f60,%eax
     699:	89 04 24             	mov    %eax,(%esp)
     69c:	e8 ff 34 00 00       	call   3ba0 <printf>
  fd = open("big", O_CREATE|O_RDWR);
     6a1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     6a8:	00 
     6a9:	c7 04 24 53 41 00 00 	movl   $0x4153,(%esp)
     6b0:	e8 e2 33 00 00       	call   3a97 <open>
     6b5:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     6b7:	85 c0                	test   %eax,%eax
     6b9:	0f 88 70 01 00 00    	js     82f <writetest1+0x1ab>
     6bf:	31 db                	xor    %ebx,%ebx
     6c1:	8d 76 00             	lea    0x0(%esi),%esi
    ((int*)buf)[0] = i;
     6c4:	89 1d 40 87 00 00    	mov    %ebx,0x8740
    if(write(fd, buf, 512) != 512){
     6ca:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     6d1:	00 
     6d2:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
     6d9:	00 
     6da:	89 34 24             	mov    %esi,(%esp)
     6dd:	e8 95 33 00 00       	call   3a77 <write>
     6e2:	3d 00 02 00 00       	cmp    $0x200,%eax
     6e7:	0f 85 a8 00 00 00    	jne    795 <writetest1+0x111>
  for(i = 0; i < MAXFILE; i++){
     6ed:	43                   	inc    %ebx
     6ee:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     6f4:	75 ce                	jne    6c4 <writetest1+0x40>
  close(fd);
     6f6:	89 34 24             	mov    %esi,(%esp)
     6f9:	e8 81 33 00 00       	call   3a7f <close>
  fd = open("big", O_RDONLY);
     6fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     705:	00 
     706:	c7 04 24 53 41 00 00 	movl   $0x4153,(%esp)
     70d:	e8 85 33 00 00       	call   3a97 <open>
     712:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     714:	85 c0                	test   %eax,%eax
     716:	0f 88 f9 00 00 00    	js     815 <writetest1+0x191>
     71c:	31 db                	xor    %ebx,%ebx
     71e:	eb 15                	jmp    735 <writetest1+0xb1>
    } else if(i != 512){
     720:	3d 00 02 00 00       	cmp    $0x200,%eax
     725:	0f 85 aa 00 00 00    	jne    7d5 <writetest1+0x151>
    if(((int*)buf)[0] != n){
     72b:	a1 40 87 00 00       	mov    0x8740,%eax
     730:	39 d8                	cmp    %ebx,%eax
     732:	75 7f                	jne    7b3 <writetest1+0x12f>
    n++;
     734:	43                   	inc    %ebx
    i = read(fd, buf, 512);
     735:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     73c:	00 
     73d:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
     744:	00 
     745:	89 34 24             	mov    %esi,(%esp)
     748:	e8 22 33 00 00       	call   3a6f <read>
    if(i == 0){
     74d:	85 c0                	test   %eax,%eax
     74f:	75 cf                	jne    720 <writetest1+0x9c>
      if(n == MAXFILE - 1){
     751:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     757:	0f 84 96 00 00 00    	je     7f3 <writetest1+0x16f>
  close(fd);
     75d:	89 34 24             	mov    %esi,(%esp)
     760:	e8 1a 33 00 00       	call   3a7f <close>
  if(unlink("big") < 0){
     765:	c7 04 24 53 41 00 00 	movl   $0x4153,(%esp)
     76c:	e8 36 33 00 00       	call   3aa7 <unlink>
     771:	85 c0                	test   %eax,%eax
     773:	0f 88 d0 00 00 00    	js     849 <writetest1+0x1c5>
  printf(stdout, "big files ok\n");
     779:	c7 44 24 04 7a 41 00 	movl   $0x417a,0x4(%esp)
     780:	00 
     781:	a1 60 5f 00 00       	mov    0x5f60,%eax
     786:	89 04 24             	mov    %eax,(%esp)
     789:	e8 12 34 00 00       	call   3ba0 <printf>
}
     78e:	83 c4 10             	add    $0x10,%esp
     791:	5b                   	pop    %ebx
     792:	5e                   	pop    %esi
     793:	5d                   	pop    %ebp
     794:	c3                   	ret    
      printf(stdout, "error: write big file failed\n", i);
     795:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     799:	c7 44 24 04 03 41 00 	movl   $0x4103,0x4(%esp)
     7a0:	00 
     7a1:	a1 60 5f 00 00       	mov    0x5f60,%eax
     7a6:	89 04 24             	mov    %eax,(%esp)
     7a9:	e8 f2 33 00 00       	call   3ba0 <printf>
      exit();
     7ae:	e8 a4 32 00 00       	call   3a57 <exit>
      printf(stdout, "read content of block %d is %d\n",
     7b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
     7b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     7bb:	c7 44 24 04 54 4f 00 	movl   $0x4f54,0x4(%esp)
     7c2:	00 
     7c3:	a1 60 5f 00 00       	mov    0x5f60,%eax
     7c8:	89 04 24             	mov    %eax,(%esp)
     7cb:	e8 d0 33 00 00       	call   3ba0 <printf>
      exit();
     7d0:	e8 82 32 00 00       	call   3a57 <exit>
      printf(stdout, "read failed %d\n", i);
     7d5:	89 44 24 08          	mov    %eax,0x8(%esp)
     7d9:	c7 44 24 04 57 41 00 	movl   $0x4157,0x4(%esp)
     7e0:	00 
     7e1:	a1 60 5f 00 00       	mov    0x5f60,%eax
     7e6:	89 04 24             	mov    %eax,(%esp)
     7e9:	e8 b2 33 00 00       	call   3ba0 <printf>
      exit();
     7ee:	e8 64 32 00 00       	call   3a57 <exit>
        printf(stdout, "read only %d blocks from big", n);
     7f3:	c7 44 24 08 8b 00 00 	movl   $0x8b,0x8(%esp)
     7fa:	00 
     7fb:	c7 44 24 04 3a 41 00 	movl   $0x413a,0x4(%esp)
     802:	00 
     803:	a1 60 5f 00 00       	mov    0x5f60,%eax
     808:	89 04 24             	mov    %eax,(%esp)
     80b:	e8 90 33 00 00       	call   3ba0 <printf>
        exit();
     810:	e8 42 32 00 00       	call   3a57 <exit>
    printf(stdout, "error: open big failed!\n");
     815:	c7 44 24 04 21 41 00 	movl   $0x4121,0x4(%esp)
     81c:	00 
     81d:	a1 60 5f 00 00       	mov    0x5f60,%eax
     822:	89 04 24             	mov    %eax,(%esp)
     825:	e8 76 33 00 00       	call   3ba0 <printf>
    exit();
     82a:	e8 28 32 00 00       	call   3a57 <exit>
    printf(stdout, "error: creat big failed!\n");
     82f:	c7 44 24 04 e9 40 00 	movl   $0x40e9,0x4(%esp)
     836:	00 
     837:	a1 60 5f 00 00       	mov    0x5f60,%eax
     83c:	89 04 24             	mov    %eax,(%esp)
     83f:	e8 5c 33 00 00       	call   3ba0 <printf>
    exit();
     844:	e8 0e 32 00 00       	call   3a57 <exit>
    printf(stdout, "unlink big failed\n");
     849:	c7 44 24 04 67 41 00 	movl   $0x4167,0x4(%esp)
     850:	00 
     851:	a1 60 5f 00 00       	mov    0x5f60,%eax
     856:	89 04 24             	mov    %eax,(%esp)
     859:	e8 42 33 00 00       	call   3ba0 <printf>
    exit();
     85e:	e8 f4 31 00 00       	call   3a57 <exit>
     863:	90                   	nop

00000864 <createtest>:
{
     864:	55                   	push   %ebp
     865:	89 e5                	mov    %esp,%ebp
     867:	53                   	push   %ebx
     868:	83 ec 14             	sub    $0x14,%esp
  printf(stdout, "many creates, followed by unlink test\n");
     86b:	c7 44 24 04 74 4f 00 	movl   $0x4f74,0x4(%esp)
     872:	00 
     873:	a1 60 5f 00 00       	mov    0x5f60,%eax
     878:	89 04 24             	mov    %eax,(%esp)
     87b:	e8 20 33 00 00       	call   3ba0 <printf>
  name[0] = 'a';
     880:	c6 05 40 a7 00 00 61 	movb   $0x61,0xa740
  name[2] = '\0';
     887:	c6 05 42 a7 00 00 00 	movb   $0x0,0xa742
     88e:	b3 30                	mov    $0x30,%bl
    name[1] = '0' + i;
     890:	88 1d 41 a7 00 00    	mov    %bl,0xa741
    fd = open(name, O_CREATE|O_RDWR);
     896:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     89d:	00 
     89e:	c7 04 24 40 a7 00 00 	movl   $0xa740,(%esp)
     8a5:	e8 ed 31 00 00       	call   3a97 <open>
    close(fd);
     8aa:	89 04 24             	mov    %eax,(%esp)
     8ad:	e8 cd 31 00 00       	call   3a7f <close>
     8b2:	43                   	inc    %ebx
  for(i = 0; i < 52; i++){
     8b3:	80 fb 64             	cmp    $0x64,%bl
     8b6:	75 d8                	jne    890 <createtest+0x2c>
  name[0] = 'a';
     8b8:	c6 05 40 a7 00 00 61 	movb   $0x61,0xa740
  name[2] = '\0';
     8bf:	c6 05 42 a7 00 00 00 	movb   $0x0,0xa742
     8c6:	b3 30                	mov    $0x30,%bl
    name[1] = '0' + i;
     8c8:	88 1d 41 a7 00 00    	mov    %bl,0xa741
    unlink(name);
     8ce:	c7 04 24 40 a7 00 00 	movl   $0xa740,(%esp)
     8d5:	e8 cd 31 00 00       	call   3aa7 <unlink>
     8da:	43                   	inc    %ebx
  for(i = 0; i < 52; i++){
     8db:	80 fb 64             	cmp    $0x64,%bl
     8de:	75 e8                	jne    8c8 <createtest+0x64>
  printf(stdout, "many creates, followed by unlink; ok\n");
     8e0:	c7 44 24 04 9c 4f 00 	movl   $0x4f9c,0x4(%esp)
     8e7:	00 
     8e8:	a1 60 5f 00 00       	mov    0x5f60,%eax
     8ed:	89 04 24             	mov    %eax,(%esp)
     8f0:	e8 ab 32 00 00       	call   3ba0 <printf>
}
     8f5:	83 c4 14             	add    $0x14,%esp
     8f8:	5b                   	pop    %ebx
     8f9:	5d                   	pop    %ebp
     8fa:	c3                   	ret    
     8fb:	90                   	nop

000008fc <dirtest>:
{
     8fc:	55                   	push   %ebp
     8fd:	89 e5                	mov    %esp,%ebp
     8ff:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
     902:	c7 44 24 04 88 41 00 	movl   $0x4188,0x4(%esp)
     909:	00 
     90a:	a1 60 5f 00 00       	mov    0x5f60,%eax
     90f:	89 04 24             	mov    %eax,(%esp)
     912:	e8 89 32 00 00       	call   3ba0 <printf>
  if(mkdir("dir0") < 0){
     917:	c7 04 24 94 41 00 00 	movl   $0x4194,(%esp)
     91e:	e8 9c 31 00 00       	call   3abf <mkdir>
     923:	85 c0                	test   %eax,%eax
     925:	78 4b                	js     972 <dirtest+0x76>
  if(chdir("dir0") < 0){
     927:	c7 04 24 94 41 00 00 	movl   $0x4194,(%esp)
     92e:	e8 94 31 00 00       	call   3ac7 <chdir>
     933:	85 c0                	test   %eax,%eax
     935:	0f 88 85 00 00 00    	js     9c0 <dirtest+0xc4>
  if(chdir("..") < 0){
     93b:	c7 04 24 39 47 00 00 	movl   $0x4739,(%esp)
     942:	e8 80 31 00 00       	call   3ac7 <chdir>
     947:	85 c0                	test   %eax,%eax
     949:	78 5b                	js     9a6 <dirtest+0xaa>
  if(unlink("dir0") < 0){
     94b:	c7 04 24 94 41 00 00 	movl   $0x4194,(%esp)
     952:	e8 50 31 00 00       	call   3aa7 <unlink>
     957:	85 c0                	test   %eax,%eax
     959:	78 31                	js     98c <dirtest+0x90>
  printf(stdout, "mkdir test ok\n");
     95b:	c7 44 24 04 d1 41 00 	movl   $0x41d1,0x4(%esp)
     962:	00 
     963:	a1 60 5f 00 00       	mov    0x5f60,%eax
     968:	89 04 24             	mov    %eax,(%esp)
     96b:	e8 30 32 00 00       	call   3ba0 <printf>
}
     970:	c9                   	leave  
     971:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     972:	c7 44 24 04 c4 3e 00 	movl   $0x3ec4,0x4(%esp)
     979:	00 
     97a:	a1 60 5f 00 00       	mov    0x5f60,%eax
     97f:	89 04 24             	mov    %eax,(%esp)
     982:	e8 19 32 00 00       	call   3ba0 <printf>
    exit();
     987:	e8 cb 30 00 00       	call   3a57 <exit>
    printf(stdout, "unlink dir0 failed\n");
     98c:	c7 44 24 04 bd 41 00 	movl   $0x41bd,0x4(%esp)
     993:	00 
     994:	a1 60 5f 00 00       	mov    0x5f60,%eax
     999:	89 04 24             	mov    %eax,(%esp)
     99c:	e8 ff 31 00 00       	call   3ba0 <printf>
    exit();
     9a1:	e8 b1 30 00 00       	call   3a57 <exit>
    printf(stdout, "chdir .. failed\n");
     9a6:	c7 44 24 04 ac 41 00 	movl   $0x41ac,0x4(%esp)
     9ad:	00 
     9ae:	a1 60 5f 00 00       	mov    0x5f60,%eax
     9b3:	89 04 24             	mov    %eax,(%esp)
     9b6:	e8 e5 31 00 00       	call   3ba0 <printf>
    exit();
     9bb:	e8 97 30 00 00       	call   3a57 <exit>
    printf(stdout, "chdir dir0 failed\n");
     9c0:	c7 44 24 04 99 41 00 	movl   $0x4199,0x4(%esp)
     9c7:	00 
     9c8:	a1 60 5f 00 00       	mov    0x5f60,%eax
     9cd:	89 04 24             	mov    %eax,(%esp)
     9d0:	e8 cb 31 00 00       	call   3ba0 <printf>
    exit();
     9d5:	e8 7d 30 00 00       	call   3a57 <exit>
     9da:	66 90                	xchg   %ax,%ax

000009dc <exectest>:
{
     9dc:	55                   	push   %ebp
     9dd:	89 e5                	mov    %esp,%ebp
     9df:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
     9e2:	c7 44 24 04 e0 41 00 	movl   $0x41e0,0x4(%esp)
     9e9:	00 
     9ea:	a1 60 5f 00 00       	mov    0x5f60,%eax
     9ef:	89 04 24             	mov    %eax,(%esp)
     9f2:	e8 a9 31 00 00       	call   3ba0 <printf>
  if(exec("echo", echoargv) < 0){
     9f7:	c7 44 24 04 64 5f 00 	movl   $0x5f64,0x4(%esp)
     9fe:	00 
     9ff:	c7 04 24 a9 3f 00 00 	movl   $0x3fa9,(%esp)
     a06:	e8 84 30 00 00       	call   3a8f <exec>
     a0b:	85 c0                	test   %eax,%eax
     a0d:	78 02                	js     a11 <exectest+0x35>
}
     a0f:	c9                   	leave  
     a10:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     a11:	c7 44 24 04 eb 41 00 	movl   $0x41eb,0x4(%esp)
     a18:	00 
     a19:	a1 60 5f 00 00       	mov    0x5f60,%eax
     a1e:	89 04 24             	mov    %eax,(%esp)
     a21:	e8 7a 31 00 00       	call   3ba0 <printf>
    exit();
     a26:	e8 2c 30 00 00       	call   3a57 <exit>
     a2b:	90                   	nop

00000a2c <pipe1>:
{
     a2c:	55                   	push   %ebp
     a2d:	89 e5                	mov    %esp,%ebp
     a2f:	57                   	push   %edi
     a30:	56                   	push   %esi
     a31:	53                   	push   %ebx
     a32:	83 ec 3c             	sub    $0x3c,%esp
  if(pipe(fds) != 0){
     a35:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a38:	89 04 24             	mov    %eax,(%esp)
     a3b:	e8 27 30 00 00       	call   3a67 <pipe>
     a40:	85 c0                	test   %eax,%eax
     a42:	0f 85 40 01 00 00    	jne    b88 <pipe1+0x15c>
  pid = fork();
     a48:	e8 02 30 00 00       	call   3a4f <fork>
  if(pid == 0){
     a4d:	83 f8 00             	cmp    $0x0,%eax
     a50:	0f 84 88 00 00 00    	je     ade <pipe1+0xb2>
  } else if(pid > 0){
     a56:	0f 8e 45 01 00 00    	jle    ba1 <pipe1+0x175>
    close(fds[1]);
     a5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     a5f:	89 04 24             	mov    %eax,(%esp)
     a62:	e8 18 30 00 00       	call   3a7f <close>
    total = 0;
     a67:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    cc = 1;
     a6e:	bf 01 00 00 00       	mov    $0x1,%edi
  seq = 0;
     a73:	31 db                	xor    %ebx,%ebx
    while((n = read(fds[0], buf, cc)) > 0){
     a75:	89 7c 24 08          	mov    %edi,0x8(%esp)
     a79:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
     a80:	00 
     a81:	8b 45 e0             	mov    -0x20(%ebp),%eax
     a84:	89 04 24             	mov    %eax,(%esp)
     a87:	e8 e3 2f 00 00       	call   3a6f <read>
     a8c:	85 c0                	test   %eax,%eax
     a8e:	0f 8e a5 00 00 00    	jle    b39 <pipe1+0x10d>
pipe1(void)
     a94:	8d 34 03             	lea    (%ebx,%eax,1),%esi
     a97:	89 d9                	mov    %ebx,%ecx
     a99:	f7 d9                	neg    %ecx
     a9b:	90                   	nop
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     a9c:	8a 94 0b 40 87 00 00 	mov    0x8740(%ebx,%ecx,1),%dl
     aa3:	31 da                	xor    %ebx,%edx
     aa5:	43                   	inc    %ebx
     aa6:	84 d2                	test   %dl,%dl
     aa8:	75 18                	jne    ac2 <pipe1+0x96>
      for(i = 0; i < n; i++){
     aaa:	39 f3                	cmp    %esi,%ebx
     aac:	75 ee                	jne    a9c <pipe1+0x70>
      total += n;
     aae:	01 45 d4             	add    %eax,-0x2c(%ebp)
      cc = cc * 2;
     ab1:	d1 e7                	shl    %edi
      if(cc > sizeof(buf))
     ab3:	81 ff 00 20 00 00    	cmp    $0x2000,%edi
     ab9:	76 ba                	jbe    a75 <pipe1+0x49>
        cc = sizeof(buf);
     abb:	bf 00 20 00 00       	mov    $0x2000,%edi
     ac0:	eb b3                	jmp    a75 <pipe1+0x49>
          printf(1, "pipe1 oops 2\n");
     ac2:	c7 44 24 04 1a 42 00 	movl   $0x421a,0x4(%esp)
     ac9:	00 
     aca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ad1:	e8 ca 30 00 00       	call   3ba0 <printf>
}
     ad6:	83 c4 3c             	add    $0x3c,%esp
     ad9:	5b                   	pop    %ebx
     ada:	5e                   	pop    %esi
     adb:	5f                   	pop    %edi
     adc:	5d                   	pop    %ebp
     add:	c3                   	ret    
    close(fds[0]);
     ade:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ae1:	89 04 24             	mov    %eax,(%esp)
     ae4:	e8 96 2f 00 00       	call   3a7f <close>
  seq = 0;
     ae9:	31 f6                	xor    %esi,%esi
pipe1(void)
     aeb:	8d 96 09 04 00 00    	lea    0x409(%esi),%edx
     af1:	89 f3                	mov    %esi,%ebx
     af3:	89 f0                	mov    %esi,%eax
     af5:	f7 d8                	neg    %eax
     af7:	90                   	nop
        buf[i] = seq++;
     af8:	88 9c 18 40 87 00 00 	mov    %bl,0x8740(%eax,%ebx,1)
     aff:	43                   	inc    %ebx
      for(i = 0; i < 1033; i++)
     b00:	39 d3                	cmp    %edx,%ebx
     b02:	75 f4                	jne    af8 <pipe1+0xcc>
     b04:	89 de                	mov    %ebx,%esi
      if(write(fds[1], buf, 1033) != 1033){
     b06:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
     b0d:	00 
     b0e:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
     b15:	00 
     b16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     b19:	89 04 24             	mov    %eax,(%esp)
     b1c:	e8 56 2f 00 00       	call   3a77 <write>
     b21:	3d 09 04 00 00       	cmp    $0x409,%eax
     b26:	0f 85 8e 00 00 00    	jne    bba <pipe1+0x18e>
    for(n = 0; n < 5; n++){
     b2c:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
     b32:	75 b7                	jne    aeb <pipe1+0xbf>
      exit();
     b34:	e8 1e 2f 00 00       	call   3a57 <exit>
    if(total != 5 * 1033){
     b39:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
     b40:	75 29                	jne    b6b <pipe1+0x13f>
    close(fds[0]);
     b42:	8b 45 e0             	mov    -0x20(%ebp),%eax
     b45:	89 04 24             	mov    %eax,(%esp)
     b48:	e8 32 2f 00 00       	call   3a7f <close>
    wait();
     b4d:	e8 0d 2f 00 00       	call   3a5f <wait>
  printf(1, "pipe1 ok\n");
     b52:	c7 44 24 04 3f 42 00 	movl   $0x423f,0x4(%esp)
     b59:	00 
     b5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b61:	e8 3a 30 00 00       	call   3ba0 <printf>
     b66:	e9 6b ff ff ff       	jmp    ad6 <pipe1+0xaa>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     b6e:	89 44 24 08          	mov    %eax,0x8(%esp)
     b72:	c7 44 24 04 28 42 00 	movl   $0x4228,0x4(%esp)
     b79:	00 
     b7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b81:	e8 1a 30 00 00       	call   3ba0 <printf>
     b86:	eb ac                	jmp    b34 <pipe1+0x108>
    printf(1, "pipe() failed\n");
     b88:	c7 44 24 04 fd 41 00 	movl   $0x41fd,0x4(%esp)
     b8f:	00 
     b90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b97:	e8 04 30 00 00       	call   3ba0 <printf>
    exit();
     b9c:	e8 b6 2e 00 00       	call   3a57 <exit>
    printf(1, "fork() failed\n");
     ba1:	c7 44 24 04 49 42 00 	movl   $0x4249,0x4(%esp)
     ba8:	00 
     ba9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     bb0:	e8 eb 2f 00 00       	call   3ba0 <printf>
    exit();
     bb5:	e8 9d 2e 00 00       	call   3a57 <exit>
        printf(1, "pipe1 oops 1\n");
     bba:	c7 44 24 04 0c 42 00 	movl   $0x420c,0x4(%esp)
     bc1:	00 
     bc2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     bc9:	e8 d2 2f 00 00       	call   3ba0 <printf>
        exit();
     bce:	e8 84 2e 00 00       	call   3a57 <exit>
     bd3:	90                   	nop

00000bd4 <preempt>:
{
     bd4:	55                   	push   %ebp
     bd5:	89 e5                	mov    %esp,%ebp
     bd7:	57                   	push   %edi
     bd8:	56                   	push   %esi
     bd9:	53                   	push   %ebx
     bda:	83 ec 2c             	sub    $0x2c,%esp
  printf(1, "preempt: ");
     bdd:	c7 44 24 04 58 42 00 	movl   $0x4258,0x4(%esp)
     be4:	00 
     be5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     bec:	e8 af 2f 00 00       	call   3ba0 <printf>
  pid1 = fork();
     bf1:	e8 59 2e 00 00       	call   3a4f <fork>
     bf6:	89 c7                	mov    %eax,%edi
  if(pid1 == 0)
     bf8:	85 c0                	test   %eax,%eax
     bfa:	75 02                	jne    bfe <preempt+0x2a>
     bfc:	eb fe                	jmp    bfc <preempt+0x28>
  pid2 = fork();
     bfe:	e8 4c 2e 00 00       	call   3a4f <fork>
     c03:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     c05:	85 c0                	test   %eax,%eax
     c07:	75 02                	jne    c0b <preempt+0x37>
     c09:	eb fe                	jmp    c09 <preempt+0x35>
  pipe(pfds);
     c0b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     c0e:	89 04 24             	mov    %eax,(%esp)
     c11:	e8 51 2e 00 00       	call   3a67 <pipe>
  pid3 = fork();
     c16:	e8 34 2e 00 00       	call   3a4f <fork>
     c1b:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     c1d:	85 c0                	test   %eax,%eax
     c1f:	75 4a                	jne    c6b <preempt+0x97>
    close(pfds[0]);
     c21:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c24:	89 04 24             	mov    %eax,(%esp)
     c27:	e8 53 2e 00 00       	call   3a7f <close>
    if(write(pfds[1], "x", 1) != 1)
     c2c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     c33:	00 
     c34:	c7 44 24 04 1d 48 00 	movl   $0x481d,0x4(%esp)
     c3b:	00 
     c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c3f:	89 04 24             	mov    %eax,(%esp)
     c42:	e8 30 2e 00 00       	call   3a77 <write>
     c47:	48                   	dec    %eax
     c48:	74 14                	je     c5e <preempt+0x8a>
      printf(1, "preempt write error");
     c4a:	c7 44 24 04 62 42 00 	movl   $0x4262,0x4(%esp)
     c51:	00 
     c52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c59:	e8 42 2f 00 00       	call   3ba0 <printf>
    close(pfds[1]);
     c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c61:	89 04 24             	mov    %eax,(%esp)
     c64:	e8 16 2e 00 00       	call   3a7f <close>
     c69:	eb fe                	jmp    c69 <preempt+0x95>
  close(pfds[1]);
     c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c6e:	89 04 24             	mov    %eax,(%esp)
     c71:	e8 09 2e 00 00       	call   3a7f <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c76:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     c7d:	00 
     c7e:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
     c85:	00 
     c86:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c89:	89 04 24             	mov    %eax,(%esp)
     c8c:	e8 de 2d 00 00       	call   3a6f <read>
     c91:	48                   	dec    %eax
     c92:	74 1c                	je     cb0 <preempt+0xdc>
    printf(1, "preempt read error");
     c94:	c7 44 24 04 76 42 00 	movl   $0x4276,0x4(%esp)
     c9b:	00 
     c9c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ca3:	e8 f8 2e 00 00       	call   3ba0 <printf>
}
     ca8:	83 c4 2c             	add    $0x2c,%esp
     cab:	5b                   	pop    %ebx
     cac:	5e                   	pop    %esi
     cad:	5f                   	pop    %edi
     cae:	5d                   	pop    %ebp
     caf:	c3                   	ret    
  close(pfds[0]);
     cb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
     cb3:	89 04 24             	mov    %eax,(%esp)
     cb6:	e8 c4 2d 00 00       	call   3a7f <close>
  printf(1, "kill... ");
     cbb:	c7 44 24 04 89 42 00 	movl   $0x4289,0x4(%esp)
     cc2:	00 
     cc3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cca:	e8 d1 2e 00 00       	call   3ba0 <printf>
  kill(pid1);
     ccf:	89 3c 24             	mov    %edi,(%esp)
     cd2:	e8 b0 2d 00 00       	call   3a87 <kill>
  kill(pid2);
     cd7:	89 34 24             	mov    %esi,(%esp)
     cda:	e8 a8 2d 00 00       	call   3a87 <kill>
  kill(pid3);
     cdf:	89 1c 24             	mov    %ebx,(%esp)
     ce2:	e8 a0 2d 00 00       	call   3a87 <kill>
  printf(1, "wait... ");
     ce7:	c7 44 24 04 92 42 00 	movl   $0x4292,0x4(%esp)
     cee:	00 
     cef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cf6:	e8 a5 2e 00 00       	call   3ba0 <printf>
  wait();
     cfb:	e8 5f 2d 00 00       	call   3a5f <wait>
  wait();
     d00:	e8 5a 2d 00 00       	call   3a5f <wait>
  wait();
     d05:	e8 55 2d 00 00       	call   3a5f <wait>
  printf(1, "preempt ok\n");
     d0a:	c7 44 24 04 9b 42 00 	movl   $0x429b,0x4(%esp)
     d11:	00 
     d12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d19:	e8 82 2e 00 00       	call   3ba0 <printf>
     d1e:	eb 88                	jmp    ca8 <preempt+0xd4>

00000d20 <exitwait>:
{
     d20:	55                   	push   %ebp
     d21:	89 e5                	mov    %esp,%ebp
     d23:	56                   	push   %esi
     d24:	53                   	push   %ebx
     d25:	83 ec 10             	sub    $0x10,%esp
     d28:	be 64 00 00 00       	mov    $0x64,%esi
     d2d:	eb 0f                	jmp    d3e <exitwait+0x1e>
     d2f:	90                   	nop
    if(pid){
     d30:	74 6d                	je     d9f <exitwait+0x7f>
      if(wait() != pid){
     d32:	e8 28 2d 00 00       	call   3a5f <wait>
     d37:	39 d8                	cmp    %ebx,%eax
     d39:	75 2d                	jne    d68 <exitwait+0x48>
  for(i = 0; i < 100; i++){
     d3b:	4e                   	dec    %esi
     d3c:	74 46                	je     d84 <exitwait+0x64>
    pid = fork();
     d3e:	e8 0c 2d 00 00       	call   3a4f <fork>
     d43:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     d45:	83 f8 00             	cmp    $0x0,%eax
     d48:	7d e6                	jge    d30 <exitwait+0x10>
      printf(1, "fork failed\n");
     d4a:	c7 44 24 04 05 4e 00 	movl   $0x4e05,0x4(%esp)
     d51:	00 
     d52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d59:	e8 42 2e 00 00       	call   3ba0 <printf>
}
     d5e:	83 c4 10             	add    $0x10,%esp
     d61:	5b                   	pop    %ebx
     d62:	5e                   	pop    %esi
     d63:	5d                   	pop    %ebp
     d64:	c3                   	ret    
     d65:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "wait wrong pid\n");
     d68:	c7 44 24 04 a7 42 00 	movl   $0x42a7,0x4(%esp)
     d6f:	00 
     d70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d77:	e8 24 2e 00 00       	call   3ba0 <printf>
}
     d7c:	83 c4 10             	add    $0x10,%esp
     d7f:	5b                   	pop    %ebx
     d80:	5e                   	pop    %esi
     d81:	5d                   	pop    %ebp
     d82:	c3                   	ret    
     d83:	90                   	nop
  printf(1, "exitwait ok\n");
     d84:	c7 44 24 04 b7 42 00 	movl   $0x42b7,0x4(%esp)
     d8b:	00 
     d8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d93:	e8 08 2e 00 00       	call   3ba0 <printf>
}
     d98:	83 c4 10             	add    $0x10,%esp
     d9b:	5b                   	pop    %ebx
     d9c:	5e                   	pop    %esi
     d9d:	5d                   	pop    %ebp
     d9e:	c3                   	ret    
      exit();
     d9f:	e8 b3 2c 00 00       	call   3a57 <exit>

00000da4 <mem>:
{
     da4:	55                   	push   %ebp
     da5:	89 e5                	mov    %esp,%ebp
     da7:	57                   	push   %edi
     da8:	56                   	push   %esi
     da9:	53                   	push   %ebx
     daa:	83 ec 1c             	sub    $0x1c,%esp
  printf(1, "mem test\n");
     dad:	c7 44 24 04 c4 42 00 	movl   $0x42c4,0x4(%esp)
     db4:	00 
     db5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     dbc:	e8 df 2d 00 00       	call   3ba0 <printf>
  ppid = getpid();
     dc1:	e8 11 2d 00 00       	call   3ad7 <getpid>
     dc6:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     dc8:	e8 82 2c 00 00       	call   3a4f <fork>
     dcd:	85 c0                	test   %eax,%eax
     dcf:	75 63                	jne    e34 <mem+0x90>
     dd1:	31 db                	xor    %ebx,%ebx
     dd3:	eb 07                	jmp    ddc <mem+0x38>
     dd5:	8d 76 00             	lea    0x0(%esi),%esi
      *(char**)m2 = m1;
     dd8:	89 18                	mov    %ebx,(%eax)
     dda:	89 c3                	mov    %eax,%ebx
    while((m2 = malloc(10001)) != 0){
     ddc:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
     de3:	e8 04 30 00 00       	call   3dec <malloc>
     de8:	85 c0                	test   %eax,%eax
     dea:	75 ec                	jne    dd8 <mem+0x34>
    while(m1){
     dec:	85 db                	test   %ebx,%ebx
     dee:	74 10                	je     e00 <mem+0x5c>
      m2 = *(char**)m1;
     df0:	8b 3b                	mov    (%ebx),%edi
      free(m1);
     df2:	89 1c 24             	mov    %ebx,(%esp)
     df5:	e8 72 2f 00 00       	call   3d6c <free>
      m1 = m2;
     dfa:	89 fb                	mov    %edi,%ebx
    while(m1){
     dfc:	85 db                	test   %ebx,%ebx
     dfe:	75 f0                	jne    df0 <mem+0x4c>
    m1 = malloc(1024*20);
     e00:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
     e07:	e8 e0 2f 00 00       	call   3dec <malloc>
    if(m1 == 0){
     e0c:	85 c0                	test   %eax,%eax
     e0e:	74 30                	je     e40 <mem+0x9c>
    free(m1);
     e10:	89 04 24             	mov    %eax,(%esp)
     e13:	e8 54 2f 00 00       	call   3d6c <free>
    printf(1, "mem ok\n");
     e18:	c7 44 24 04 e8 42 00 	movl   $0x42e8,0x4(%esp)
     e1f:	00 
     e20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e27:	e8 74 2d 00 00       	call   3ba0 <printf>
    exit();
     e2c:	e8 26 2c 00 00       	call   3a57 <exit>
     e31:	8d 76 00             	lea    0x0(%esi),%esi
}
     e34:	83 c4 1c             	add    $0x1c,%esp
     e37:	5b                   	pop    %ebx
     e38:	5e                   	pop    %esi
     e39:	5f                   	pop    %edi
     e3a:	5d                   	pop    %ebp
    wait();
     e3b:	e9 1f 2c 00 00       	jmp    3a5f <wait>
      printf(1, "couldn't allocate mem?!!\n");
     e40:	c7 44 24 04 ce 42 00 	movl   $0x42ce,0x4(%esp)
     e47:	00 
     e48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e4f:	e8 4c 2d 00 00       	call   3ba0 <printf>
      kill(ppid);
     e54:	89 34 24             	mov    %esi,(%esp)
     e57:	e8 2b 2c 00 00       	call   3a87 <kill>
      exit();
     e5c:	e8 f6 2b 00 00       	call   3a57 <exit>
     e61:	8d 76 00             	lea    0x0(%esi),%esi

00000e64 <sharedfd>:
{
     e64:	55                   	push   %ebp
     e65:	89 e5                	mov    %esp,%ebp
     e67:	57                   	push   %edi
     e68:	56                   	push   %esi
     e69:	53                   	push   %ebx
     e6a:	83 ec 3c             	sub    $0x3c,%esp
  printf(1, "sharedfd test\n");
     e6d:	c7 44 24 04 f0 42 00 	movl   $0x42f0,0x4(%esp)
     e74:	00 
     e75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e7c:	e8 1f 2d 00 00       	call   3ba0 <printf>
  unlink("sharedfd");
     e81:	c7 04 24 ff 42 00 00 	movl   $0x42ff,(%esp)
     e88:	e8 1a 2c 00 00       	call   3aa7 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e8d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     e94:	00 
     e95:	c7 04 24 ff 42 00 00 	movl   $0x42ff,(%esp)
     e9c:	e8 f6 2b 00 00       	call   3a97 <open>
     ea1:	89 c7                	mov    %eax,%edi
  if(fd < 0){
     ea3:	85 c0                	test   %eax,%eax
     ea5:	0f 88 2e 01 00 00    	js     fd9 <sharedfd+0x175>
  pid = fork();
     eab:	e8 9f 2b 00 00       	call   3a4f <fork>
     eb0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     eb3:	83 f8 01             	cmp    $0x1,%eax
     eb6:	19 c0                	sbb    %eax,%eax
     eb8:	83 e0 f3             	and    $0xfffffff3,%eax
     ebb:	83 c0 70             	add    $0x70,%eax
     ebe:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     ec5:	00 
     ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
     eca:	8d 75 de             	lea    -0x22(%ebp),%esi
     ecd:	89 34 24             	mov    %esi,(%esp)
     ed0:	e8 2f 2a 00 00       	call   3904 <memset>
     ed5:	bb e8 03 00 00       	mov    $0x3e8,%ebx
     eda:	eb 03                	jmp    edf <sharedfd+0x7b>
  for(i = 0; i < 1000; i++){
     edc:	4b                   	dec    %ebx
     edd:	74 2d                	je     f0c <sharedfd+0xa8>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     edf:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     ee6:	00 
     ee7:	89 74 24 04          	mov    %esi,0x4(%esp)
     eeb:	89 3c 24             	mov    %edi,(%esp)
     eee:	e8 84 2b 00 00       	call   3a77 <write>
     ef3:	83 f8 0a             	cmp    $0xa,%eax
     ef6:	74 e4                	je     edc <sharedfd+0x78>
      printf(1, "fstests: write sharedfd failed\n");
     ef8:	c7 44 24 04 f0 4f 00 	movl   $0x4ff0,0x4(%esp)
     eff:	00 
     f00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f07:	e8 94 2c 00 00       	call   3ba0 <printf>
  if(pid == 0)
     f0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     f0f:	85 c0                	test   %eax,%eax
     f11:	0f 84 16 01 00 00    	je     102d <sharedfd+0x1c9>
    wait();
     f17:	e8 43 2b 00 00       	call   3a5f <wait>
  close(fd);
     f1c:	89 3c 24             	mov    %edi,(%esp)
     f1f:	e8 5b 2b 00 00       	call   3a7f <close>
  fd = open("sharedfd", 0);
     f24:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     f2b:	00 
     f2c:	c7 04 24 ff 42 00 00 	movl   $0x42ff,(%esp)
     f33:	e8 5f 2b 00 00       	call   3a97 <open>
     f38:	89 45 d0             	mov    %eax,-0x30(%ebp)
  if(fd < 0){
     f3b:	85 c0                	test   %eax,%eax
     f3d:	0f 88 b2 00 00 00    	js     ff5 <sharedfd+0x191>
     f43:	31 ff                	xor    %edi,%edi
sharedfd(void)
     f45:	8d 5d e8             	lea    -0x18(%ebp),%ebx
     f48:	89 7d d4             	mov    %edi,-0x2c(%ebp)
     f4b:	90                   	nop
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f4c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     f53:	00 
     f54:	89 74 24 04          	mov    %esi,0x4(%esp)
     f58:	8b 45 d0             	mov    -0x30(%ebp),%eax
     f5b:	89 04 24             	mov    %eax,(%esp)
     f5e:	e8 0c 2b 00 00       	call   3a6f <read>
     f63:	85 c0                	test   %eax,%eax
     f65:	7e 24                	jle    f8b <sharedfd+0x127>
     f67:	89 f1                	mov    %esi,%ecx
     f69:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     f6c:	eb 0c                	jmp    f7a <sharedfd+0x116>
     f6e:	66 90                	xchg   %ax,%ax
      if(buf[i] == 'p')
     f70:	3c 70                	cmp    $0x70,%al
     f72:	75 01                	jne    f75 <sharedfd+0x111>
        np++;
     f74:	47                   	inc    %edi
     f75:	41                   	inc    %ecx
    for(i = 0; i < sizeof(buf); i++){
     f76:	39 d9                	cmp    %ebx,%ecx
     f78:	74 0c                	je     f86 <sharedfd+0x122>
      if(buf[i] == 'c')
     f7a:	8a 01                	mov    (%ecx),%al
     f7c:	3c 63                	cmp    $0x63,%al
     f7e:	75 f0                	jne    f70 <sharedfd+0x10c>
        nc++;
     f80:	42                   	inc    %edx
     f81:	41                   	inc    %ecx
    for(i = 0; i < sizeof(buf); i++){
     f82:	39 d9                	cmp    %ebx,%ecx
     f84:	75 f4                	jne    f7a <sharedfd+0x116>
     f86:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     f89:	eb c1                	jmp    f4c <sharedfd+0xe8>
     f8b:	89 fa                	mov    %edi,%edx
     f8d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  close(fd);
     f90:	8b 45 d0             	mov    -0x30(%ebp),%eax
     f93:	89 04 24             	mov    %eax,(%esp)
     f96:	89 55 cc             	mov    %edx,-0x34(%ebp)
     f99:	e8 e1 2a 00 00       	call   3a7f <close>
  unlink("sharedfd");
     f9e:	c7 04 24 ff 42 00 00 	movl   $0x42ff,(%esp)
     fa5:	e8 fd 2a 00 00       	call   3aa7 <unlink>
  if(nc == 10000 && np == 10000){
     faa:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
     fb0:	8b 55 cc             	mov    -0x34(%ebp),%edx
     fb3:	75 5c                	jne    1011 <sharedfd+0x1ad>
     fb5:	81 fa 10 27 00 00    	cmp    $0x2710,%edx
     fbb:	75 54                	jne    1011 <sharedfd+0x1ad>
    printf(1, "sharedfd ok\n");
     fbd:	c7 44 24 04 08 43 00 	movl   $0x4308,0x4(%esp)
     fc4:	00 
     fc5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fcc:	e8 cf 2b 00 00       	call   3ba0 <printf>
}
     fd1:	83 c4 3c             	add    $0x3c,%esp
     fd4:	5b                   	pop    %ebx
     fd5:	5e                   	pop    %esi
     fd6:	5f                   	pop    %edi
     fd7:	5d                   	pop    %ebp
     fd8:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for writing");
     fd9:	c7 44 24 04 c4 4f 00 	movl   $0x4fc4,0x4(%esp)
     fe0:	00 
     fe1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fe8:	e8 b3 2b 00 00       	call   3ba0 <printf>
}
     fed:	83 c4 3c             	add    $0x3c,%esp
     ff0:	5b                   	pop    %ebx
     ff1:	5e                   	pop    %esi
     ff2:	5f                   	pop    %edi
     ff3:	5d                   	pop    %ebp
     ff4:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for reading\n");
     ff5:	c7 44 24 04 10 50 00 	movl   $0x5010,0x4(%esp)
     ffc:	00 
     ffd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1004:	e8 97 2b 00 00       	call   3ba0 <printf>
}
    1009:	83 c4 3c             	add    $0x3c,%esp
    100c:	5b                   	pop    %ebx
    100d:	5e                   	pop    %esi
    100e:	5f                   	pop    %edi
    100f:	5d                   	pop    %ebp
    1010:	c3                   	ret    
    printf(1, "sharedfd oops %d %d\n", nc, np);
    1011:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1015:	89 7c 24 08          	mov    %edi,0x8(%esp)
    1019:	c7 44 24 04 15 43 00 	movl   $0x4315,0x4(%esp)
    1020:	00 
    1021:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1028:	e8 73 2b 00 00       	call   3ba0 <printf>
    exit();
    102d:	e8 25 2a 00 00       	call   3a57 <exit>
    1032:	66 90                	xchg   %ax,%ax

00001034 <fourfiles>:
{
    1034:	55                   	push   %ebp
    1035:	89 e5                	mov    %esp,%ebp
    1037:	57                   	push   %edi
    1038:	56                   	push   %esi
    1039:	53                   	push   %ebx
    103a:	83 ec 3c             	sub    $0x3c,%esp
  char *names[] = { "f0", "f1", "f2", "f3" };
    103d:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1040:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1043:	be 5c 56 00 00       	mov    $0x565c,%esi
    1048:	b9 04 00 00 00       	mov    $0x4,%ecx
    104d:	89 c7                	mov    %eax,%edi
    104f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  printf(1, "fourfiles test\n");
    1051:	c7 44 24 04 2a 43 00 	movl   $0x432a,0x4(%esp)
    1058:	00 
    1059:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1060:	e8 3b 2b 00 00       	call   3ba0 <printf>
  for(pi = 0; pi < 4; pi++){
    1065:	31 db                	xor    %ebx,%ebx
    fname = names[pi];
    1067:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    unlink(fname);
    106b:	89 34 24             	mov    %esi,(%esp)
    106e:	e8 34 2a 00 00       	call   3aa7 <unlink>
    pid = fork();
    1073:	e8 d7 29 00 00       	call   3a4f <fork>
    if(pid < 0){
    1078:	83 f8 00             	cmp    $0x0,%eax
    107b:	0f 8c 6b 01 00 00    	jl     11ec <fourfiles+0x1b8>
    if(pid == 0){
    1081:	0f 84 cb 00 00 00    	je     1152 <fourfiles+0x11e>
  for(pi = 0; pi < 4; pi++){
    1087:	43                   	inc    %ebx
    1088:	83 fb 04             	cmp    $0x4,%ebx
    108b:	75 da                	jne    1067 <fourfiles+0x33>
    wait();
    108d:	e8 cd 29 00 00       	call   3a5f <wait>
    1092:	e8 c8 29 00 00       	call   3a5f <wait>
    1097:	e8 c3 29 00 00       	call   3a5f <wait>
    109c:	e8 be 29 00 00       	call   3a5f <wait>
    10a1:	bf 30 00 00 00       	mov    $0x30,%edi
    fname = names[i];
    10a6:	8b 84 bd 18 ff ff ff 	mov    -0xe8(%ebp,%edi,4),%eax
    10ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
    fd = open(fname, 0);
    10b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10b7:	00 
    10b8:	89 04 24             	mov    %eax,(%esp)
    10bb:	e8 d7 29 00 00       	call   3a97 <open>
    10c0:	89 c3                	mov    %eax,%ebx
    total = 0;
    10c2:	31 f6                	xor    %esi,%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
    10c4:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    10cb:	00 
    10cc:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
    10d3:	00 
    10d4:	89 1c 24             	mov    %ebx,(%esp)
    10d7:	e8 93 29 00 00       	call   3a6f <read>
    10dc:	85 c0                	test   %eax,%eax
    10de:	7e 18                	jle    10f8 <fourfiles+0xc4>
    10e0:	31 d2                	xor    %edx,%edx
    10e2:	66 90                	xchg   %ax,%ax
        if(buf[j] != '0'+i){
    10e4:	0f be 8a 40 87 00 00 	movsbl 0x8740(%edx),%ecx
    10eb:	39 f9                	cmp    %edi,%ecx
    10ed:	75 4a                	jne    1139 <fourfiles+0x105>
      for(j = 0; j < n; j++){
    10ef:	42                   	inc    %edx
    10f0:	39 c2                	cmp    %eax,%edx
    10f2:	75 f0                	jne    10e4 <fourfiles+0xb0>
      total += n;
    10f4:	01 d6                	add    %edx,%esi
    10f6:	eb cc                	jmp    10c4 <fourfiles+0x90>
    close(fd);
    10f8:	89 1c 24             	mov    %ebx,(%esp)
    10fb:	e8 7f 29 00 00       	call   3a7f <close>
    if(total != 12*500){
    1100:	81 fe 70 17 00 00    	cmp    $0x1770,%esi
    1106:	0f 85 c3 00 00 00    	jne    11cf <fourfiles+0x19b>
    unlink(fname);
    110c:	8b 45 d0             	mov    -0x30(%ebp),%eax
    110f:	89 04 24             	mov    %eax,(%esp)
    1112:	e8 90 29 00 00       	call   3aa7 <unlink>
    1117:	47                   	inc    %edi
  for(i = 0; i < 2; i++){
    1118:	83 ff 32             	cmp    $0x32,%edi
    111b:	75 89                	jne    10a6 <fourfiles+0x72>
  printf(1, "fourfiles ok\n");
    111d:	c7 44 24 04 68 43 00 	movl   $0x4368,0x4(%esp)
    1124:	00 
    1125:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    112c:	e8 6f 2a 00 00       	call   3ba0 <printf>
}
    1131:	83 c4 3c             	add    $0x3c,%esp
    1134:	5b                   	pop    %ebx
    1135:	5e                   	pop    %esi
    1136:	5f                   	pop    %edi
    1137:	5d                   	pop    %ebp
    1138:	c3                   	ret    
          printf(1, "wrong char\n");
    1139:	c7 44 24 04 4b 43 00 	movl   $0x434b,0x4(%esp)
    1140:	00 
    1141:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1148:	e8 53 2a 00 00       	call   3ba0 <printf>
          exit();
    114d:	e8 05 29 00 00       	call   3a57 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    1152:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1159:	00 
    115a:	89 34 24             	mov    %esi,(%esp)
    115d:	e8 35 29 00 00       	call   3a97 <open>
    1162:	89 c6                	mov    %eax,%esi
      if(fd < 0){
    1164:	85 c0                	test   %eax,%eax
    1166:	0f 88 99 00 00 00    	js     1205 <fourfiles+0x1d1>
      memset(buf, '0'+pi, 512);
    116c:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    1173:	00 
    1174:	83 c3 30             	add    $0x30,%ebx
    1177:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    117b:	c7 04 24 40 87 00 00 	movl   $0x8740,(%esp)
    1182:	e8 7d 27 00 00       	call   3904 <memset>
    1187:	bb 0c 00 00 00       	mov    $0xc,%ebx
    118c:	eb 05                	jmp    1193 <fourfiles+0x15f>
    118e:	66 90                	xchg   %ax,%ax
      for(i = 0; i < 12; i++){
    1190:	4b                   	dec    %ebx
    1191:	74 ba                	je     114d <fourfiles+0x119>
        if((n = write(fd, buf, 500)) != 500){
    1193:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    119a:	00 
    119b:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
    11a2:	00 
    11a3:	89 34 24             	mov    %esi,(%esp)
    11a6:	e8 cc 28 00 00       	call   3a77 <write>
    11ab:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    11b0:	74 de                	je     1190 <fourfiles+0x15c>
          printf(1, "write failed %d\n", n);
    11b2:	89 44 24 08          	mov    %eax,0x8(%esp)
    11b6:	c7 44 24 04 3a 43 00 	movl   $0x433a,0x4(%esp)
    11bd:	00 
    11be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11c5:	e8 d6 29 00 00       	call   3ba0 <printf>
          exit();
    11ca:	e8 88 28 00 00       	call   3a57 <exit>
      printf(1, "wrong length %d\n", total);
    11cf:	89 74 24 08          	mov    %esi,0x8(%esp)
    11d3:	c7 44 24 04 57 43 00 	movl   $0x4357,0x4(%esp)
    11da:	00 
    11db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11e2:	e8 b9 29 00 00       	call   3ba0 <printf>
      exit();
    11e7:	e8 6b 28 00 00       	call   3a57 <exit>
      printf(1, "fork failed\n");
    11ec:	c7 44 24 04 05 4e 00 	movl   $0x4e05,0x4(%esp)
    11f3:	00 
    11f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11fb:	e8 a0 29 00 00       	call   3ba0 <printf>
      exit();
    1200:	e8 52 28 00 00       	call   3a57 <exit>
        printf(1, "create failed\n");
    1205:	c7 44 24 04 cb 45 00 	movl   $0x45cb,0x4(%esp)
    120c:	00 
    120d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1214:	e8 87 29 00 00       	call   3ba0 <printf>
        exit();
    1219:	e8 39 28 00 00       	call   3a57 <exit>
    121e:	66 90                	xchg   %ax,%ax

00001220 <createdelete>:
{
    1220:	55                   	push   %ebp
    1221:	89 e5                	mov    %esp,%ebp
    1223:	57                   	push   %edi
    1224:	56                   	push   %esi
    1225:	53                   	push   %ebx
    1226:	83 ec 4c             	sub    $0x4c,%esp
  printf(1, "createdelete test\n");
    1229:	c7 44 24 04 7c 43 00 	movl   $0x437c,0x4(%esp)
    1230:	00 
    1231:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1238:	e8 63 29 00 00       	call   3ba0 <printf>
  for(pi = 0; pi < 4; pi++){
    123d:	31 db                	xor    %ebx,%ebx
    pid = fork();
    123f:	e8 0b 28 00 00       	call   3a4f <fork>
    if(pid < 0){
    1244:	83 f8 00             	cmp    $0x0,%eax
    1247:	0f 8c 7e 01 00 00    	jl     13cb <createdelete+0x1ab>
    if(pid == 0){
    124d:	0f 84 e0 00 00 00    	je     1333 <createdelete+0x113>
  for(pi = 0; pi < 4; pi++){
    1253:	43                   	inc    %ebx
    1254:	83 fb 04             	cmp    $0x4,%ebx
    1257:	75 e6                	jne    123f <createdelete+0x1f>
    wait();
    1259:	e8 01 28 00 00       	call   3a5f <wait>
    125e:	e8 fc 27 00 00       	call   3a5f <wait>
    1263:	e8 f7 27 00 00       	call   3a5f <wait>
    1268:	e8 f2 27 00 00       	call   3a5f <wait>
  name[0] = name[1] = name[2] = 0;
    126d:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
  for(i = 0; i < N; i++){
    1271:	31 f6                	xor    %esi,%esi
    1273:	8d 7d c8             	lea    -0x38(%ebp),%edi
    1276:	66 90                	xchg   %ax,%ax
createdelete(void)
    1278:	8d 46 30             	lea    0x30(%esi),%eax
    127b:	88 45 c7             	mov    %al,-0x39(%ebp)
    127e:	b3 70                	mov    $0x70,%bl
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1280:	8d 46 ff             	lea    -0x1(%esi),%eax
    1283:	89 45 c0             	mov    %eax,-0x40(%ebp)
      name[0] = 'p' + pi;
    1286:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[1] = '0' + i;
    1289:	8a 45 c7             	mov    -0x39(%ebp),%al
    128c:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    128f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1296:	00 
    1297:	89 3c 24             	mov    %edi,(%esp)
    129a:	e8 f8 27 00 00       	call   3a97 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    129f:	85 f6                	test   %esi,%esi
    12a1:	74 05                	je     12a8 <createdelete+0x88>
    12a3:	83 fe 09             	cmp    $0x9,%esi
    12a6:	7e 2c                	jle    12d4 <createdelete+0xb4>
    12a8:	85 c0                	test   %eax,%eax
    12aa:	0f 88 d1 00 00 00    	js     1381 <createdelete+0x161>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    12b0:	83 7d c0 08          	cmpl   $0x8,-0x40(%ebp)
    12b4:	77 73                	ja     1329 <createdelete+0x109>
        printf(1, "oops createdelete %s did exist\n", name);
    12b6:	89 7c 24 08          	mov    %edi,0x8(%esp)
    12ba:	c7 44 24 04 60 50 00 	movl   $0x5060,0x4(%esp)
    12c1:	00 
    12c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12c9:	e8 d2 28 00 00       	call   3ba0 <printf>
        exit();
    12ce:	e8 84 27 00 00       	call   3a57 <exit>
    12d3:	90                   	nop
      } else if((i >= 1 && i < N/2) && fd >= 0){
    12d4:	85 c0                	test   %eax,%eax
    12d6:	79 de                	jns    12b6 <createdelete+0x96>
    12d8:	43                   	inc    %ebx
    for(pi = 0; pi < 4; pi++){
    12d9:	80 fb 74             	cmp    $0x74,%bl
    12dc:	75 a8                	jne    1286 <createdelete+0x66>
  for(i = 0; i < N; i++){
    12de:	46                   	inc    %esi
    12df:	83 fe 14             	cmp    $0x14,%esi
    12e2:	75 94                	jne    1278 <createdelete+0x58>
    12e4:	b3 70                	mov    $0x70,%bl
    12e6:	66 90                	xchg   %ax,%ax
createdelete(void)
    12e8:	8d 43 c0             	lea    -0x40(%ebx),%eax
    12eb:	88 45 c7             	mov    %al,-0x39(%ebp)
    12ee:	be 04 00 00 00       	mov    $0x4,%esi
      name[0] = 'p' + i;
    12f3:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[1] = '0' + i;
    12f6:	8a 45 c7             	mov    -0x39(%ebp),%al
    12f9:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    12fc:	89 3c 24             	mov    %edi,(%esp)
    12ff:	e8 a3 27 00 00       	call   3aa7 <unlink>
    for(pi = 0; pi < 4; pi++){
    1304:	4e                   	dec    %esi
    1305:	75 ec                	jne    12f3 <createdelete+0xd3>
    1307:	43                   	inc    %ebx
  for(i = 0; i < N; i++){
    1308:	80 fb 84             	cmp    $0x84,%bl
    130b:	75 db                	jne    12e8 <createdelete+0xc8>
  printf(1, "createdelete ok\n");
    130d:	c7 44 24 04 8f 43 00 	movl   $0x438f,0x4(%esp)
    1314:	00 
    1315:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    131c:	e8 7f 28 00 00       	call   3ba0 <printf>
}
    1321:	83 c4 4c             	add    $0x4c,%esp
    1324:	5b                   	pop    %ebx
    1325:	5e                   	pop    %esi
    1326:	5f                   	pop    %edi
    1327:	5d                   	pop    %ebp
    1328:	c3                   	ret    
        close(fd);
    1329:	89 04 24             	mov    %eax,(%esp)
    132c:	e8 4e 27 00 00       	call   3a7f <close>
    1331:	eb a5                	jmp    12d8 <createdelete+0xb8>
      name[0] = 'p' + pi;
    1333:	83 c3 70             	add    $0x70,%ebx
    1336:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[2] = '\0';
    1339:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    133d:	bb 01 00 00 00       	mov    $0x1,%ebx
    1342:	8d 7d c8             	lea    -0x38(%ebp),%edi
    1345:	8d 76 00             	lea    0x0(%esi),%esi
createdelete(void)
    1348:	8d 73 ff             	lea    -0x1(%ebx),%esi
    134b:	8d 43 2f             	lea    0x2f(%ebx),%eax
    134e:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    1351:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1358:	00 
    1359:	89 3c 24             	mov    %edi,(%esp)
    135c:	e8 36 27 00 00       	call   3a97 <open>
        if(fd < 0){
    1361:	85 c0                	test   %eax,%eax
    1363:	78 7f                	js     13e4 <createdelete+0x1c4>
        close(fd);
    1365:	89 04 24             	mov    %eax,(%esp)
    1368:	e8 12 27 00 00       	call   3a7f <close>
        if(i > 0 && (i % 2 ) == 0){
    136d:	85 f6                	test   %esi,%esi
    136f:	74 0d                	je     137e <createdelete+0x15e>
    1371:	f7 c6 01 00 00 00    	test   $0x1,%esi
    1377:	74 25                	je     139e <createdelete+0x17e>
      for(i = 0; i < N; i++){
    1379:	83 fb 14             	cmp    $0x14,%ebx
    137c:	74 1b                	je     1399 <createdelete+0x179>
    137e:	43                   	inc    %ebx
    137f:	eb c7                	jmp    1348 <createdelete+0x128>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1381:	89 7c 24 08          	mov    %edi,0x8(%esp)
    1385:	c7 44 24 04 3c 50 00 	movl   $0x503c,0x4(%esp)
    138c:	00 
    138d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1394:	e8 07 28 00 00       	call   3ba0 <printf>
        exit();
    1399:	e8 b9 26 00 00       	call   3a57 <exit>
          name[1] = '0' + (i / 2);
    139e:	d1 fe                	sar    %esi
    13a0:	8d 46 30             	lea    0x30(%esi),%eax
    13a3:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    13a6:	89 3c 24             	mov    %edi,(%esp)
    13a9:	e8 f9 26 00 00       	call   3aa7 <unlink>
    13ae:	85 c0                	test   %eax,%eax
    13b0:	79 c7                	jns    1379 <createdelete+0x159>
            printf(1, "unlink failed\n");
    13b2:	c7 44 24 04 7d 3f 00 	movl   $0x3f7d,0x4(%esp)
    13b9:	00 
    13ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13c1:	e8 da 27 00 00       	call   3ba0 <printf>
            exit();
    13c6:	e8 8c 26 00 00       	call   3a57 <exit>
      printf(1, "fork failed\n");
    13cb:	c7 44 24 04 05 4e 00 	movl   $0x4e05,0x4(%esp)
    13d2:	00 
    13d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13da:	e8 c1 27 00 00       	call   3ba0 <printf>
      exit();
    13df:	e8 73 26 00 00       	call   3a57 <exit>
          printf(1, "create failed\n");
    13e4:	c7 44 24 04 cb 45 00 	movl   $0x45cb,0x4(%esp)
    13eb:	00 
    13ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13f3:	e8 a8 27 00 00       	call   3ba0 <printf>
          exit();
    13f8:	e8 5a 26 00 00       	call   3a57 <exit>
    13fd:	8d 76 00             	lea    0x0(%esi),%esi

00001400 <unlinkread>:
{
    1400:	55                   	push   %ebp
    1401:	89 e5                	mov    %esp,%ebp
    1403:	56                   	push   %esi
    1404:	53                   	push   %ebx
    1405:	83 ec 10             	sub    $0x10,%esp
  printf(1, "unlinkread test\n");
    1408:	c7 44 24 04 a0 43 00 	movl   $0x43a0,0x4(%esp)
    140f:	00 
    1410:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1417:	e8 84 27 00 00       	call   3ba0 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    141c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1423:	00 
    1424:	c7 04 24 b1 43 00 00 	movl   $0x43b1,(%esp)
    142b:	e8 67 26 00 00       	call   3a97 <open>
    1430:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1432:	85 c0                	test   %eax,%eax
    1434:	0f 88 fe 00 00 00    	js     1538 <unlinkread+0x138>
  write(fd, "hello", 5);
    143a:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1441:	00 
    1442:	c7 44 24 04 d6 43 00 	movl   $0x43d6,0x4(%esp)
    1449:	00 
    144a:	89 04 24             	mov    %eax,(%esp)
    144d:	e8 25 26 00 00       	call   3a77 <write>
  close(fd);
    1452:	89 1c 24             	mov    %ebx,(%esp)
    1455:	e8 25 26 00 00       	call   3a7f <close>
  fd = open("unlinkread", O_RDWR);
    145a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1461:	00 
    1462:	c7 04 24 b1 43 00 00 	movl   $0x43b1,(%esp)
    1469:	e8 29 26 00 00       	call   3a97 <open>
    146e:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1470:	85 c0                	test   %eax,%eax
    1472:	0f 88 3d 01 00 00    	js     15b5 <unlinkread+0x1b5>
  if(unlink("unlinkread") != 0){
    1478:	c7 04 24 b1 43 00 00 	movl   $0x43b1,(%esp)
    147f:	e8 23 26 00 00       	call   3aa7 <unlink>
    1484:	85 c0                	test   %eax,%eax
    1486:	0f 85 10 01 00 00    	jne    159c <unlinkread+0x19c>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    148c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1493:	00 
    1494:	c7 04 24 b1 43 00 00 	movl   $0x43b1,(%esp)
    149b:	e8 f7 25 00 00       	call   3a97 <open>
    14a0:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    14a2:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    14a9:	00 
    14aa:	c7 44 24 04 0e 44 00 	movl   $0x440e,0x4(%esp)
    14b1:	00 
    14b2:	89 04 24             	mov    %eax,(%esp)
    14b5:	e8 bd 25 00 00       	call   3a77 <write>
  close(fd1);
    14ba:	89 34 24             	mov    %esi,(%esp)
    14bd:	e8 bd 25 00 00       	call   3a7f <close>
  if(read(fd, buf, sizeof(buf)) != 5){
    14c2:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    14c9:	00 
    14ca:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
    14d1:	00 
    14d2:	89 1c 24             	mov    %ebx,(%esp)
    14d5:	e8 95 25 00 00       	call   3a6f <read>
    14da:	83 f8 05             	cmp    $0x5,%eax
    14dd:	0f 85 a0 00 00 00    	jne    1583 <unlinkread+0x183>
  if(buf[0] != 'h'){
    14e3:	80 3d 40 87 00 00 68 	cmpb   $0x68,0x8740
    14ea:	75 7e                	jne    156a <unlinkread+0x16a>
  if(write(fd, buf, 10) != 10){
    14ec:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14f3:	00 
    14f4:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
    14fb:	00 
    14fc:	89 1c 24             	mov    %ebx,(%esp)
    14ff:	e8 73 25 00 00       	call   3a77 <write>
    1504:	83 f8 0a             	cmp    $0xa,%eax
    1507:	75 48                	jne    1551 <unlinkread+0x151>
  close(fd);
    1509:	89 1c 24             	mov    %ebx,(%esp)
    150c:	e8 6e 25 00 00       	call   3a7f <close>
  unlink("unlinkread");
    1511:	c7 04 24 b1 43 00 00 	movl   $0x43b1,(%esp)
    1518:	e8 8a 25 00 00       	call   3aa7 <unlink>
  printf(1, "unlinkread ok\n");
    151d:	c7 44 24 04 59 44 00 	movl   $0x4459,0x4(%esp)
    1524:	00 
    1525:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    152c:	e8 6f 26 00 00       	call   3ba0 <printf>
}
    1531:	83 c4 10             	add    $0x10,%esp
    1534:	5b                   	pop    %ebx
    1535:	5e                   	pop    %esi
    1536:	5d                   	pop    %ebp
    1537:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    1538:	c7 44 24 04 bc 43 00 	movl   $0x43bc,0x4(%esp)
    153f:	00 
    1540:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1547:	e8 54 26 00 00       	call   3ba0 <printf>
    exit();
    154c:	e8 06 25 00 00       	call   3a57 <exit>
    printf(1, "unlinkread write failed\n");
    1551:	c7 44 24 04 40 44 00 	movl   $0x4440,0x4(%esp)
    1558:	00 
    1559:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1560:	e8 3b 26 00 00       	call   3ba0 <printf>
    exit();
    1565:	e8 ed 24 00 00       	call   3a57 <exit>
    printf(1, "unlinkread wrong data\n");
    156a:	c7 44 24 04 29 44 00 	movl   $0x4429,0x4(%esp)
    1571:	00 
    1572:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1579:	e8 22 26 00 00       	call   3ba0 <printf>
    exit();
    157e:	e8 d4 24 00 00       	call   3a57 <exit>
    printf(1, "unlinkread read failed");
    1583:	c7 44 24 04 12 44 00 	movl   $0x4412,0x4(%esp)
    158a:	00 
    158b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1592:	e8 09 26 00 00       	call   3ba0 <printf>
    exit();
    1597:	e8 bb 24 00 00       	call   3a57 <exit>
    printf(1, "unlink unlinkread failed\n");
    159c:	c7 44 24 04 f4 43 00 	movl   $0x43f4,0x4(%esp)
    15a3:	00 
    15a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15ab:	e8 f0 25 00 00       	call   3ba0 <printf>
    exit();
    15b0:	e8 a2 24 00 00       	call   3a57 <exit>
    printf(1, "open unlinkread failed\n");
    15b5:	c7 44 24 04 dc 43 00 	movl   $0x43dc,0x4(%esp)
    15bc:	00 
    15bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15c4:	e8 d7 25 00 00       	call   3ba0 <printf>
    exit();
    15c9:	e8 89 24 00 00       	call   3a57 <exit>
    15ce:	66 90                	xchg   %ax,%ax

000015d0 <linktest>:
{
    15d0:	55                   	push   %ebp
    15d1:	89 e5                	mov    %esp,%ebp
    15d3:	53                   	push   %ebx
    15d4:	83 ec 14             	sub    $0x14,%esp
  printf(1, "linktest\n");
    15d7:	c7 44 24 04 68 44 00 	movl   $0x4468,0x4(%esp)
    15de:	00 
    15df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15e6:	e8 b5 25 00 00       	call   3ba0 <printf>
  unlink("lf1");
    15eb:	c7 04 24 72 44 00 00 	movl   $0x4472,(%esp)
    15f2:	e8 b0 24 00 00       	call   3aa7 <unlink>
  unlink("lf2");
    15f7:	c7 04 24 76 44 00 00 	movl   $0x4476,(%esp)
    15fe:	e8 a4 24 00 00       	call   3aa7 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    1603:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    160a:	00 
    160b:	c7 04 24 72 44 00 00 	movl   $0x4472,(%esp)
    1612:	e8 80 24 00 00       	call   3a97 <open>
    1617:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1619:	85 c0                	test   %eax,%eax
    161b:	0f 88 26 01 00 00    	js     1747 <linktest+0x177>
  if(write(fd, "hello", 5) != 5){
    1621:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1628:	00 
    1629:	c7 44 24 04 d6 43 00 	movl   $0x43d6,0x4(%esp)
    1630:	00 
    1631:	89 04 24             	mov    %eax,(%esp)
    1634:	e8 3e 24 00 00       	call   3a77 <write>
    1639:	83 f8 05             	cmp    $0x5,%eax
    163c:	0f 85 cd 01 00 00    	jne    180f <linktest+0x23f>
  close(fd);
    1642:	89 1c 24             	mov    %ebx,(%esp)
    1645:	e8 35 24 00 00       	call   3a7f <close>
  if(link("lf1", "lf2") < 0){
    164a:	c7 44 24 04 76 44 00 	movl   $0x4476,0x4(%esp)
    1651:	00 
    1652:	c7 04 24 72 44 00 00 	movl   $0x4472,(%esp)
    1659:	e8 59 24 00 00       	call   3ab7 <link>
    165e:	85 c0                	test   %eax,%eax
    1660:	0f 88 90 01 00 00    	js     17f6 <linktest+0x226>
  unlink("lf1");
    1666:	c7 04 24 72 44 00 00 	movl   $0x4472,(%esp)
    166d:	e8 35 24 00 00       	call   3aa7 <unlink>
  if(open("lf1", 0) >= 0){
    1672:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1679:	00 
    167a:	c7 04 24 72 44 00 00 	movl   $0x4472,(%esp)
    1681:	e8 11 24 00 00       	call   3a97 <open>
    1686:	85 c0                	test   %eax,%eax
    1688:	0f 89 4f 01 00 00    	jns    17dd <linktest+0x20d>
  fd = open("lf2", 0);
    168e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1695:	00 
    1696:	c7 04 24 76 44 00 00 	movl   $0x4476,(%esp)
    169d:	e8 f5 23 00 00       	call   3a97 <open>
    16a2:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    16a4:	85 c0                	test   %eax,%eax
    16a6:	0f 88 18 01 00 00    	js     17c4 <linktest+0x1f4>
  if(read(fd, buf, sizeof(buf)) != 5){
    16ac:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    16b3:	00 
    16b4:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
    16bb:	00 
    16bc:	89 04 24             	mov    %eax,(%esp)
    16bf:	e8 ab 23 00 00       	call   3a6f <read>
    16c4:	83 f8 05             	cmp    $0x5,%eax
    16c7:	0f 85 de 00 00 00    	jne    17ab <linktest+0x1db>
  close(fd);
    16cd:	89 1c 24             	mov    %ebx,(%esp)
    16d0:	e8 aa 23 00 00       	call   3a7f <close>
  if(link("lf2", "lf2") >= 0){
    16d5:	c7 44 24 04 76 44 00 	movl   $0x4476,0x4(%esp)
    16dc:	00 
    16dd:	c7 04 24 76 44 00 00 	movl   $0x4476,(%esp)
    16e4:	e8 ce 23 00 00       	call   3ab7 <link>
    16e9:	85 c0                	test   %eax,%eax
    16eb:	0f 89 a1 00 00 00    	jns    1792 <linktest+0x1c2>
  unlink("lf2");
    16f1:	c7 04 24 76 44 00 00 	movl   $0x4476,(%esp)
    16f8:	e8 aa 23 00 00       	call   3aa7 <unlink>
  if(link("lf2", "lf1") >= 0){
    16fd:	c7 44 24 04 72 44 00 	movl   $0x4472,0x4(%esp)
    1704:	00 
    1705:	c7 04 24 76 44 00 00 	movl   $0x4476,(%esp)
    170c:	e8 a6 23 00 00       	call   3ab7 <link>
    1711:	85 c0                	test   %eax,%eax
    1713:	79 64                	jns    1779 <linktest+0x1a9>
  if(link(".", "lf1") >= 0){
    1715:	c7 44 24 04 72 44 00 	movl   $0x4472,0x4(%esp)
    171c:	00 
    171d:	c7 04 24 3a 47 00 00 	movl   $0x473a,(%esp)
    1724:	e8 8e 23 00 00       	call   3ab7 <link>
    1729:	85 c0                	test   %eax,%eax
    172b:	79 33                	jns    1760 <linktest+0x190>
  printf(1, "linktest ok\n");
    172d:	c7 44 24 04 10 45 00 	movl   $0x4510,0x4(%esp)
    1734:	00 
    1735:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    173c:	e8 5f 24 00 00       	call   3ba0 <printf>
}
    1741:	83 c4 14             	add    $0x14,%esp
    1744:	5b                   	pop    %ebx
    1745:	5d                   	pop    %ebp
    1746:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    1747:	c7 44 24 04 7a 44 00 	movl   $0x447a,0x4(%esp)
    174e:	00 
    174f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1756:	e8 45 24 00 00       	call   3ba0 <printf>
    exit();
    175b:	e8 f7 22 00 00       	call   3a57 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    1760:	c7 44 24 04 f4 44 00 	movl   $0x44f4,0x4(%esp)
    1767:	00 
    1768:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    176f:	e8 2c 24 00 00       	call   3ba0 <printf>
    exit();
    1774:	e8 de 22 00 00       	call   3a57 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    1779:	c7 44 24 04 a8 50 00 	movl   $0x50a8,0x4(%esp)
    1780:	00 
    1781:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1788:	e8 13 24 00 00       	call   3ba0 <printf>
    exit();
    178d:	e8 c5 22 00 00       	call   3a57 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1792:	c7 44 24 04 d6 44 00 	movl   $0x44d6,0x4(%esp)
    1799:	00 
    179a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17a1:	e8 fa 23 00 00       	call   3ba0 <printf>
    exit();
    17a6:	e8 ac 22 00 00       	call   3a57 <exit>
    printf(1, "read lf2 failed\n");
    17ab:	c7 44 24 04 c5 44 00 	movl   $0x44c5,0x4(%esp)
    17b2:	00 
    17b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17ba:	e8 e1 23 00 00       	call   3ba0 <printf>
    exit();
    17bf:	e8 93 22 00 00       	call   3a57 <exit>
    printf(1, "open lf2 failed\n");
    17c4:	c7 44 24 04 b4 44 00 	movl   $0x44b4,0x4(%esp)
    17cb:	00 
    17cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17d3:	e8 c8 23 00 00       	call   3ba0 <printf>
    exit();
    17d8:	e8 7a 22 00 00       	call   3a57 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    17dd:	c7 44 24 04 80 50 00 	movl   $0x5080,0x4(%esp)
    17e4:	00 
    17e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17ec:	e8 af 23 00 00       	call   3ba0 <printf>
    exit();
    17f1:	e8 61 22 00 00       	call   3a57 <exit>
    printf(1, "link lf1 lf2 failed\n");
    17f6:	c7 44 24 04 9f 44 00 	movl   $0x449f,0x4(%esp)
    17fd:	00 
    17fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1805:	e8 96 23 00 00       	call   3ba0 <printf>
    exit();
    180a:	e8 48 22 00 00       	call   3a57 <exit>
    printf(1, "write lf1 failed\n");
    180f:	c7 44 24 04 8d 44 00 	movl   $0x448d,0x4(%esp)
    1816:	00 
    1817:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    181e:	e8 7d 23 00 00       	call   3ba0 <printf>
    exit();
    1823:	e8 2f 22 00 00       	call   3a57 <exit>

00001828 <concreate>:
{
    1828:	55                   	push   %ebp
    1829:	89 e5                	mov    %esp,%ebp
    182b:	57                   	push   %edi
    182c:	56                   	push   %esi
    182d:	53                   	push   %ebx
    182e:	83 ec 6c             	sub    $0x6c,%esp
  printf(1, "concreate test\n");
    1831:	c7 44 24 04 1d 45 00 	movl   $0x451d,0x4(%esp)
    1838:	00 
    1839:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1840:	e8 5b 23 00 00       	call   3ba0 <printf>
  file[0] = 'C';
    1845:	c6 45 ad 43          	movb   $0x43,-0x53(%ebp)
  file[2] = '\0';
    1849:	c6 45 af 00          	movb   $0x0,-0x51(%ebp)
  for(i = 0; i < 40; i++){
    184d:	31 db                	xor    %ebx,%ebx
    184f:	8d 75 ad             	lea    -0x53(%ebp),%esi
    1852:	eb 3a                	jmp    188e <concreate+0x66>
    if(pid && (i % 3) == 1){
    1854:	b9 03 00 00 00       	mov    $0x3,%ecx
    1859:	99                   	cltd   
    185a:	f7 f9                	idiv   %ecx
    185c:	4a                   	dec    %edx
    185d:	74 6d                	je     18cc <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    185f:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1866:	00 
    1867:	89 34 24             	mov    %esi,(%esp)
    186a:	e8 28 22 00 00       	call   3a97 <open>
      if(fd < 0){
    186f:	85 c0                	test   %eax,%eax
    1871:	0f 88 16 02 00 00    	js     1a8d <concreate+0x265>
      close(fd);
    1877:	89 04 24             	mov    %eax,(%esp)
    187a:	e8 00 22 00 00       	call   3a7f <close>
    if(pid == 0)
    187f:	85 ff                	test   %edi,%edi
    1881:	74 41                	je     18c4 <concreate+0x9c>
      wait();
    1883:	e8 d7 21 00 00       	call   3a5f <wait>
  for(i = 0; i < 40; i++){
    1888:	43                   	inc    %ebx
    1889:	83 fb 28             	cmp    $0x28,%ebx
    188c:	74 5a                	je     18e8 <concreate+0xc0>
concreate(void)
    188e:	8d 43 30             	lea    0x30(%ebx),%eax
    1891:	88 45 ae             	mov    %al,-0x52(%ebp)
    unlink(file);
    1894:	89 34 24             	mov    %esi,(%esp)
    1897:	e8 0b 22 00 00       	call   3aa7 <unlink>
    pid = fork();
    189c:	e8 ae 21 00 00       	call   3a4f <fork>
    18a1:	89 c7                	mov    %eax,%edi
    if(pid && (i % 3) == 1){
    18a3:	89 d8                	mov    %ebx,%eax
    18a5:	85 ff                	test   %edi,%edi
    18a7:	75 ab                	jne    1854 <concreate+0x2c>
    } else if(pid == 0 && (i % 5) == 1){
    18a9:	b9 05 00 00 00       	mov    $0x5,%ecx
    18ae:	99                   	cltd   
    18af:	f7 f9                	idiv   %ecx
    18b1:	4a                   	dec    %edx
    18b2:	75 ab                	jne    185f <concreate+0x37>
      link("C0", file);
    18b4:	89 74 24 04          	mov    %esi,0x4(%esp)
    18b8:	c7 04 24 2d 45 00 00 	movl   $0x452d,(%esp)
    18bf:	e8 f3 21 00 00       	call   3ab7 <link>
        exit();
    18c4:	e8 8e 21 00 00       	call   3a57 <exit>
    18c9:	8d 76 00             	lea    0x0(%esi),%esi
      link("C0", file);
    18cc:	89 74 24 04          	mov    %esi,0x4(%esp)
    18d0:	c7 04 24 2d 45 00 00 	movl   $0x452d,(%esp)
    18d7:	e8 db 21 00 00       	call   3ab7 <link>
      wait();
    18dc:	e8 7e 21 00 00       	call   3a5f <wait>
  for(i = 0; i < 40; i++){
    18e1:	43                   	inc    %ebx
    18e2:	83 fb 28             	cmp    $0x28,%ebx
    18e5:	75 a7                	jne    188e <concreate+0x66>
    18e7:	90                   	nop
  memset(fa, 0, sizeof(fa));
    18e8:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    18ef:	00 
    18f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    18f7:	00 
    18f8:	8d 45 c0             	lea    -0x40(%ebp),%eax
    18fb:	89 04 24             	mov    %eax,(%esp)
    18fe:	e8 01 20 00 00       	call   3904 <memset>
  fd = open(".", 0);
    1903:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    190a:	00 
    190b:	c7 04 24 3a 47 00 00 	movl   $0x473a,(%esp)
    1912:	e8 80 21 00 00       	call   3a97 <open>
    1917:	89 c3                	mov    %eax,%ebx
  n = 0;
    1919:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
    1920:	8d 7d b0             	lea    -0x50(%ebp),%edi
    1923:	90                   	nop
  while(read(fd, &de, sizeof(de)) > 0){
    1924:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    192b:	00 
    192c:	89 7c 24 04          	mov    %edi,0x4(%esp)
    1930:	89 1c 24             	mov    %ebx,(%esp)
    1933:	e8 37 21 00 00       	call   3a6f <read>
    1938:	85 c0                	test   %eax,%eax
    193a:	7e 38                	jle    1974 <concreate+0x14c>
    if(de.inum == 0)
    193c:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
    1941:	74 e1                	je     1924 <concreate+0xfc>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1943:	80 7d b2 43          	cmpb   $0x43,-0x4e(%ebp)
    1947:	75 db                	jne    1924 <concreate+0xfc>
    1949:	80 7d b4 00          	cmpb   $0x0,-0x4c(%ebp)
    194d:	75 d5                	jne    1924 <concreate+0xfc>
      i = de.name[1] - '0';
    194f:	0f be 45 b3          	movsbl -0x4d(%ebp),%eax
    1953:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    1956:	83 f8 27             	cmp    $0x27,%eax
    1959:	0f 87 4b 01 00 00    	ja     1aaa <concreate+0x282>
      if(fa[i]){
    195f:	80 7c 05 c0 00       	cmpb   $0x0,-0x40(%ebp,%eax,1)
    1964:	0f 85 79 01 00 00    	jne    1ae3 <concreate+0x2bb>
      fa[i] = 1;
    196a:	c6 44 05 c0 01       	movb   $0x1,-0x40(%ebp,%eax,1)
      n++;
    196f:	ff 45 a4             	incl   -0x5c(%ebp)
    1972:	eb b0                	jmp    1924 <concreate+0xfc>
  close(fd);
    1974:	89 1c 24             	mov    %ebx,(%esp)
    1977:	e8 03 21 00 00       	call   3a7f <close>
  if(n != 40){
    197c:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    1980:	0f 85 44 01 00 00    	jne    1aca <concreate+0x2a2>
    1986:	31 db                	xor    %ebx,%ebx
    1988:	eb 7d                	jmp    1a07 <concreate+0x1df>
    198a:	66 90                	xchg   %ax,%ax
    if(((i % 3) == 0 && pid == 0) ||
    198c:	85 ff                	test   %edi,%edi
    198e:	0f 85 a1 00 00 00    	jne    1a35 <concreate+0x20d>
      close(open(file, 0));
    1994:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    199b:	00 
    199c:	89 34 24             	mov    %esi,(%esp)
    199f:	e8 f3 20 00 00       	call   3a97 <open>
    19a4:	89 04 24             	mov    %eax,(%esp)
    19a7:	e8 d3 20 00 00       	call   3a7f <close>
      close(open(file, 0));
    19ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    19b3:	00 
    19b4:	89 34 24             	mov    %esi,(%esp)
    19b7:	e8 db 20 00 00       	call   3a97 <open>
    19bc:	89 04 24             	mov    %eax,(%esp)
    19bf:	e8 bb 20 00 00       	call   3a7f <close>
      close(open(file, 0));
    19c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    19cb:	00 
    19cc:	89 34 24             	mov    %esi,(%esp)
    19cf:	e8 c3 20 00 00       	call   3a97 <open>
    19d4:	89 04 24             	mov    %eax,(%esp)
    19d7:	e8 a3 20 00 00       	call   3a7f <close>
      close(open(file, 0));
    19dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    19e3:	00 
    19e4:	89 34 24             	mov    %esi,(%esp)
    19e7:	e8 ab 20 00 00       	call   3a97 <open>
    19ec:	89 04 24             	mov    %eax,(%esp)
    19ef:	e8 8b 20 00 00       	call   3a7f <close>
    if(pid == 0)
    19f4:	85 ff                	test   %edi,%edi
    19f6:	0f 84 c8 fe ff ff    	je     18c4 <concreate+0x9c>
      wait();
    19fc:	e8 5e 20 00 00       	call   3a5f <wait>
  for(i = 0; i < 40; i++){
    1a01:	43                   	inc    %ebx
    1a02:	83 fb 28             	cmp    $0x28,%ebx
    1a05:	74 51                	je     1a58 <concreate+0x230>
concreate(void)
    1a07:	8d 43 30             	lea    0x30(%ebx),%eax
    1a0a:	88 45 ae             	mov    %al,-0x52(%ebp)
    pid = fork();
    1a0d:	e8 3d 20 00 00       	call   3a4f <fork>
    1a12:	89 c7                	mov    %eax,%edi
    if(pid < 0){
    1a14:	85 c0                	test   %eax,%eax
    1a16:	78 5c                	js     1a74 <concreate+0x24c>
    if(((i % 3) == 0 && pid == 0) ||
    1a18:	89 d8                	mov    %ebx,%eax
    1a1a:	b9 03 00 00 00       	mov    $0x3,%ecx
    1a1f:	99                   	cltd   
    1a20:	f7 f9                	idiv   %ecx
    1a22:	85 d2                	test   %edx,%edx
    1a24:	0f 84 62 ff ff ff    	je     198c <concreate+0x164>
    1a2a:	4a                   	dec    %edx
    1a2b:	75 08                	jne    1a35 <concreate+0x20d>
       ((i % 3) == 1 && pid != 0)){
    1a2d:	85 ff                	test   %edi,%edi
    1a2f:	0f 85 5f ff ff ff    	jne    1994 <concreate+0x16c>
      unlink(file);
    1a35:	89 34 24             	mov    %esi,(%esp)
    1a38:	e8 6a 20 00 00       	call   3aa7 <unlink>
      unlink(file);
    1a3d:	89 34 24             	mov    %esi,(%esp)
    1a40:	e8 62 20 00 00       	call   3aa7 <unlink>
      unlink(file);
    1a45:	89 34 24             	mov    %esi,(%esp)
    1a48:	e8 5a 20 00 00       	call   3aa7 <unlink>
      unlink(file);
    1a4d:	89 34 24             	mov    %esi,(%esp)
    1a50:	e8 52 20 00 00       	call   3aa7 <unlink>
    1a55:	eb 9d                	jmp    19f4 <concreate+0x1cc>
    1a57:	90                   	nop
  printf(1, "concreate ok\n");
    1a58:	c7 44 24 04 82 45 00 	movl   $0x4582,0x4(%esp)
    1a5f:	00 
    1a60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a67:	e8 34 21 00 00       	call   3ba0 <printf>
}
    1a6c:	83 c4 6c             	add    $0x6c,%esp
    1a6f:	5b                   	pop    %ebx
    1a70:	5e                   	pop    %esi
    1a71:	5f                   	pop    %edi
    1a72:	5d                   	pop    %ebp
    1a73:	c3                   	ret    
      printf(1, "fork failed\n");
    1a74:	c7 44 24 04 05 4e 00 	movl   $0x4e05,0x4(%esp)
    1a7b:	00 
    1a7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a83:	e8 18 21 00 00       	call   3ba0 <printf>
      exit();
    1a88:	e8 ca 1f 00 00       	call   3a57 <exit>
        printf(1, "concreate create %s failed\n", file);
    1a8d:	89 74 24 08          	mov    %esi,0x8(%esp)
    1a91:	c7 44 24 04 30 45 00 	movl   $0x4530,0x4(%esp)
    1a98:	00 
    1a99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1aa0:	e8 fb 20 00 00       	call   3ba0 <printf>
        exit();
    1aa5:	e8 ad 1f 00 00       	call   3a57 <exit>
        printf(1, "concreate weird file %s\n", de.name);
    1aaa:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1aad:	89 44 24 08          	mov    %eax,0x8(%esp)
    1ab1:	c7 44 24 04 4c 45 00 	movl   $0x454c,0x4(%esp)
    1ab8:	00 
    1ab9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ac0:	e8 db 20 00 00       	call   3ba0 <printf>
    1ac5:	e9 fa fd ff ff       	jmp    18c4 <concreate+0x9c>
    printf(1, "concreate not enough files in directory listing\n");
    1aca:	c7 44 24 04 cc 50 00 	movl   $0x50cc,0x4(%esp)
    1ad1:	00 
    1ad2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ad9:	e8 c2 20 00 00       	call   3ba0 <printf>
    exit();
    1ade:	e8 74 1f 00 00       	call   3a57 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    1ae3:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1ae6:	89 44 24 08          	mov    %eax,0x8(%esp)
    1aea:	c7 44 24 04 65 45 00 	movl   $0x4565,0x4(%esp)
    1af1:	00 
    1af2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1af9:	e8 a2 20 00 00       	call   3ba0 <printf>
        exit();
    1afe:	e8 54 1f 00 00       	call   3a57 <exit>
    1b03:	90                   	nop

00001b04 <linkunlink>:
{
    1b04:	55                   	push   %ebp
    1b05:	89 e5                	mov    %esp,%ebp
    1b07:	57                   	push   %edi
    1b08:	56                   	push   %esi
    1b09:	53                   	push   %ebx
    1b0a:	83 ec 2c             	sub    $0x2c,%esp
  printf(1, "linkunlink test\n");
    1b0d:	c7 44 24 04 90 45 00 	movl   $0x4590,0x4(%esp)
    1b14:	00 
    1b15:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b1c:	e8 7f 20 00 00       	call   3ba0 <printf>
  unlink("x");
    1b21:	c7 04 24 1d 48 00 00 	movl   $0x481d,(%esp)
    1b28:	e8 7a 1f 00 00       	call   3aa7 <unlink>
  pid = fork();
    1b2d:	e8 1d 1f 00 00       	call   3a4f <fork>
    1b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    1b35:	85 c0                	test   %eax,%eax
    1b37:	0f 88 c0 00 00 00    	js     1bfd <linkunlink+0xf9>
  unsigned int x = (pid ? 1 : 97);
    1b3d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1b41:	19 ff                	sbb    %edi,%edi
    1b43:	83 e7 60             	and    $0x60,%edi
    1b46:	47                   	inc    %edi
    1b47:	bb 64 00 00 00       	mov    $0x64,%ebx
    if((x % 3) == 0){
    1b4c:	be 03 00 00 00       	mov    $0x3,%esi
    1b51:	eb 17                	jmp    1b6a <linkunlink+0x66>
    1b53:	90                   	nop
    } else if((x % 3) == 1){
    1b54:	4a                   	dec    %edx
    1b55:	0f 84 89 00 00 00    	je     1be4 <linkunlink+0xe0>
      unlink("x");
    1b5b:	c7 04 24 1d 48 00 00 	movl   $0x481d,(%esp)
    1b62:	e8 40 1f 00 00       	call   3aa7 <unlink>
  for(i = 0; i < 100; i++){
    1b67:	4b                   	dec    %ebx
    1b68:	74 50                	je     1bba <linkunlink+0xb6>
    x = x * 1103515245 + 12345;
    1b6a:	89 f8                	mov    %edi,%eax
    1b6c:	c1 e0 09             	shl    $0x9,%eax
    1b6f:	29 f8                	sub    %edi,%eax
    1b71:	8d 14 87             	lea    (%edi,%eax,4),%edx
    1b74:	89 d0                	mov    %edx,%eax
    1b76:	c1 e0 09             	shl    $0x9,%eax
    1b79:	29 d0                	sub    %edx,%eax
    1b7b:	8d 04 47             	lea    (%edi,%eax,2),%eax
    1b7e:	89 c2                	mov    %eax,%edx
    1b80:	c1 e2 05             	shl    $0x5,%edx
    1b83:	01 d0                	add    %edx,%eax
    1b85:	c1 e0 02             	shl    $0x2,%eax
    1b88:	29 f8                	sub    %edi,%eax
    1b8a:	8d bc 87 39 30 00 00 	lea    0x3039(%edi,%eax,4),%edi
    if((x % 3) == 0){
    1b91:	89 f8                	mov    %edi,%eax
    1b93:	31 d2                	xor    %edx,%edx
    1b95:	f7 f6                	div    %esi
    1b97:	85 d2                	test   %edx,%edx
    1b99:	75 b9                	jne    1b54 <linkunlink+0x50>
      close(open("x", O_RDWR | O_CREATE));
    1b9b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1ba2:	00 
    1ba3:	c7 04 24 1d 48 00 00 	movl   $0x481d,(%esp)
    1baa:	e8 e8 1e 00 00       	call   3a97 <open>
    1baf:	89 04 24             	mov    %eax,(%esp)
    1bb2:	e8 c8 1e 00 00       	call   3a7f <close>
  for(i = 0; i < 100; i++){
    1bb7:	4b                   	dec    %ebx
    1bb8:	75 b0                	jne    1b6a <linkunlink+0x66>
  if(pid)
    1bba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    1bbd:	85 d2                	test   %edx,%edx
    1bbf:	74 55                	je     1c16 <linkunlink+0x112>
    wait();
    1bc1:	e8 99 1e 00 00       	call   3a5f <wait>
  printf(1, "linkunlink ok\n");
    1bc6:	c7 44 24 04 a5 45 00 	movl   $0x45a5,0x4(%esp)
    1bcd:	00 
    1bce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bd5:	e8 c6 1f 00 00       	call   3ba0 <printf>
}
    1bda:	83 c4 2c             	add    $0x2c,%esp
    1bdd:	5b                   	pop    %ebx
    1bde:	5e                   	pop    %esi
    1bdf:	5f                   	pop    %edi
    1be0:	5d                   	pop    %ebp
    1be1:	c3                   	ret    
    1be2:	66 90                	xchg   %ax,%ax
      link("cat", "x");
    1be4:	c7 44 24 04 1d 48 00 	movl   $0x481d,0x4(%esp)
    1beb:	00 
    1bec:	c7 04 24 a1 45 00 00 	movl   $0x45a1,(%esp)
    1bf3:	e8 bf 1e 00 00       	call   3ab7 <link>
    1bf8:	e9 6a ff ff ff       	jmp    1b67 <linkunlink+0x63>
    printf(1, "fork failed\n");
    1bfd:	c7 44 24 04 05 4e 00 	movl   $0x4e05,0x4(%esp)
    1c04:	00 
    1c05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c0c:	e8 8f 1f 00 00       	call   3ba0 <printf>
    exit();
    1c11:	e8 41 1e 00 00       	call   3a57 <exit>
    exit();
    1c16:	e8 3c 1e 00 00       	call   3a57 <exit>
    1c1b:	90                   	nop

00001c1c <bigdir>:
{
    1c1c:	55                   	push   %ebp
    1c1d:	89 e5                	mov    %esp,%ebp
    1c1f:	56                   	push   %esi
    1c20:	53                   	push   %ebx
    1c21:	83 ec 20             	sub    $0x20,%esp
  printf(1, "bigdir test\n");
    1c24:	c7 44 24 04 b4 45 00 	movl   $0x45b4,0x4(%esp)
    1c2b:	00 
    1c2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c33:	e8 68 1f 00 00       	call   3ba0 <printf>
  unlink("bd");
    1c38:	c7 04 24 c1 45 00 00 	movl   $0x45c1,(%esp)
    1c3f:	e8 63 1e 00 00       	call   3aa7 <unlink>
  fd = open("bd", O_CREATE);
    1c44:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1c4b:	00 
    1c4c:	c7 04 24 c1 45 00 00 	movl   $0x45c1,(%esp)
    1c53:	e8 3f 1e 00 00       	call   3a97 <open>
  if(fd < 0){
    1c58:	85 c0                	test   %eax,%eax
    1c5a:	0f 88 dc 00 00 00    	js     1d3c <bigdir+0x120>
  close(fd);
    1c60:	89 04 24             	mov    %eax,(%esp)
    1c63:	e8 17 1e 00 00       	call   3a7f <close>
  for(i = 0; i < 500; i++){
    1c68:	31 db                	xor    %ebx,%ebx
    1c6a:	8d 75 ee             	lea    -0x12(%ebp),%esi
    1c6d:	8d 76 00             	lea    0x0(%esi),%esi
    name[0] = 'x';
    1c70:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    1c74:	89 d8                	mov    %ebx,%eax
    1c76:	c1 f8 06             	sar    $0x6,%eax
    1c79:	83 c0 30             	add    $0x30,%eax
    1c7c:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1c7f:	89 d8                	mov    %ebx,%eax
    1c81:	83 e0 3f             	and    $0x3f,%eax
    1c84:	83 c0 30             	add    $0x30,%eax
    1c87:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1c8a:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(link("bd", name) != 0){
    1c8e:	89 74 24 04          	mov    %esi,0x4(%esp)
    1c92:	c7 04 24 c1 45 00 00 	movl   $0x45c1,(%esp)
    1c99:	e8 19 1e 00 00       	call   3ab7 <link>
    1c9e:	85 c0                	test   %eax,%eax
    1ca0:	75 68                	jne    1d0a <bigdir+0xee>
  for(i = 0; i < 500; i++){
    1ca2:	43                   	inc    %ebx
    1ca3:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1ca9:	75 c5                	jne    1c70 <bigdir+0x54>
  unlink("bd");
    1cab:	c7 04 24 c1 45 00 00 	movl   $0x45c1,(%esp)
    1cb2:	e8 f0 1d 00 00       	call   3aa7 <unlink>
  for(i = 0; i < 500; i++){
    1cb7:	66 31 db             	xor    %bx,%bx
    1cba:	66 90                	xchg   %ax,%ax
    name[0] = 'x';
    1cbc:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    1cc0:	89 d8                	mov    %ebx,%eax
    1cc2:	c1 f8 06             	sar    $0x6,%eax
    1cc5:	83 c0 30             	add    $0x30,%eax
    1cc8:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1ccb:	89 d8                	mov    %ebx,%eax
    1ccd:	83 e0 3f             	and    $0x3f,%eax
    1cd0:	83 c0 30             	add    $0x30,%eax
    1cd3:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1cd6:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(unlink(name) != 0){
    1cda:	89 34 24             	mov    %esi,(%esp)
    1cdd:	e8 c5 1d 00 00       	call   3aa7 <unlink>
    1ce2:	85 c0                	test   %eax,%eax
    1ce4:	75 3d                	jne    1d23 <bigdir+0x107>
  for(i = 0; i < 500; i++){
    1ce6:	43                   	inc    %ebx
    1ce7:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1ced:	75 cd                	jne    1cbc <bigdir+0xa0>
  printf(1, "bigdir ok\n");
    1cef:	c7 44 24 04 03 46 00 	movl   $0x4603,0x4(%esp)
    1cf6:	00 
    1cf7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cfe:	e8 9d 1e 00 00       	call   3ba0 <printf>
}
    1d03:	83 c4 20             	add    $0x20,%esp
    1d06:	5b                   	pop    %ebx
    1d07:	5e                   	pop    %esi
    1d08:	5d                   	pop    %ebp
    1d09:	c3                   	ret    
      printf(1, "bigdir link failed\n");
    1d0a:	c7 44 24 04 da 45 00 	movl   $0x45da,0x4(%esp)
    1d11:	00 
    1d12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d19:	e8 82 1e 00 00       	call   3ba0 <printf>
      exit();
    1d1e:	e8 34 1d 00 00       	call   3a57 <exit>
      printf(1, "bigdir unlink failed");
    1d23:	c7 44 24 04 ee 45 00 	movl   $0x45ee,0x4(%esp)
    1d2a:	00 
    1d2b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d32:	e8 69 1e 00 00       	call   3ba0 <printf>
      exit();
    1d37:	e8 1b 1d 00 00       	call   3a57 <exit>
    printf(1, "bigdir create failed\n");
    1d3c:	c7 44 24 04 c4 45 00 	movl   $0x45c4,0x4(%esp)
    1d43:	00 
    1d44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d4b:	e8 50 1e 00 00       	call   3ba0 <printf>
    exit();
    1d50:	e8 02 1d 00 00       	call   3a57 <exit>
    1d55:	8d 76 00             	lea    0x0(%esi),%esi

00001d58 <subdir>:
{
    1d58:	55                   	push   %ebp
    1d59:	89 e5                	mov    %esp,%ebp
    1d5b:	53                   	push   %ebx
    1d5c:	83 ec 14             	sub    $0x14,%esp
  printf(1, "subdir test\n");
    1d5f:	c7 44 24 04 0e 46 00 	movl   $0x460e,0x4(%esp)
    1d66:	00 
    1d67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d6e:	e8 2d 1e 00 00       	call   3ba0 <printf>
  unlink("ff");
    1d73:	c7 04 24 97 46 00 00 	movl   $0x4697,(%esp)
    1d7a:	e8 28 1d 00 00       	call   3aa7 <unlink>
  if(mkdir("dd") != 0){
    1d7f:	c7 04 24 34 47 00 00 	movl   $0x4734,(%esp)
    1d86:	e8 34 1d 00 00       	call   3abf <mkdir>
    1d8b:	85 c0                	test   %eax,%eax
    1d8d:	0f 85 07 06 00 00    	jne    239a <subdir+0x642>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1d93:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d9a:	00 
    1d9b:	c7 04 24 6d 46 00 00 	movl   $0x466d,(%esp)
    1da2:	e8 f0 1c 00 00       	call   3a97 <open>
    1da7:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1da9:	85 c0                	test   %eax,%eax
    1dab:	0f 88 d0 05 00 00    	js     2381 <subdir+0x629>
  write(fd, "ff", 2);
    1db1:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1db8:	00 
    1db9:	c7 44 24 04 97 46 00 	movl   $0x4697,0x4(%esp)
    1dc0:	00 
    1dc1:	89 04 24             	mov    %eax,(%esp)
    1dc4:	e8 ae 1c 00 00       	call   3a77 <write>
  close(fd);
    1dc9:	89 1c 24             	mov    %ebx,(%esp)
    1dcc:	e8 ae 1c 00 00       	call   3a7f <close>
  if(unlink("dd") >= 0){
    1dd1:	c7 04 24 34 47 00 00 	movl   $0x4734,(%esp)
    1dd8:	e8 ca 1c 00 00       	call   3aa7 <unlink>
    1ddd:	85 c0                	test   %eax,%eax
    1ddf:	0f 89 83 05 00 00    	jns    2368 <subdir+0x610>
  if(mkdir("/dd/dd") != 0){
    1de5:	c7 04 24 48 46 00 00 	movl   $0x4648,(%esp)
    1dec:	e8 ce 1c 00 00       	call   3abf <mkdir>
    1df1:	85 c0                	test   %eax,%eax
    1df3:	0f 85 56 05 00 00    	jne    234f <subdir+0x5f7>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1df9:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1e00:	00 
    1e01:	c7 04 24 6a 46 00 00 	movl   $0x466a,(%esp)
    1e08:	e8 8a 1c 00 00       	call   3a97 <open>
    1e0d:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e0f:	85 c0                	test   %eax,%eax
    1e11:	0f 88 25 04 00 00    	js     223c <subdir+0x4e4>
  write(fd, "FF", 2);
    1e17:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1e1e:	00 
    1e1f:	c7 44 24 04 8b 46 00 	movl   $0x468b,0x4(%esp)
    1e26:	00 
    1e27:	89 04 24             	mov    %eax,(%esp)
    1e2a:	e8 48 1c 00 00       	call   3a77 <write>
  close(fd);
    1e2f:	89 1c 24             	mov    %ebx,(%esp)
    1e32:	e8 48 1c 00 00       	call   3a7f <close>
  fd = open("dd/dd/../ff", 0);
    1e37:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1e3e:	00 
    1e3f:	c7 04 24 8e 46 00 00 	movl   $0x468e,(%esp)
    1e46:	e8 4c 1c 00 00       	call   3a97 <open>
    1e4b:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e4d:	85 c0                	test   %eax,%eax
    1e4f:	0f 88 ce 03 00 00    	js     2223 <subdir+0x4cb>
  cc = read(fd, buf, sizeof(buf));
    1e55:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1e5c:	00 
    1e5d:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
    1e64:	00 
    1e65:	89 04 24             	mov    %eax,(%esp)
    1e68:	e8 02 1c 00 00       	call   3a6f <read>
  if(cc != 2 || buf[0] != 'f'){
    1e6d:	83 f8 02             	cmp    $0x2,%eax
    1e70:	0f 85 fe 02 00 00    	jne    2174 <subdir+0x41c>
    1e76:	80 3d 40 87 00 00 66 	cmpb   $0x66,0x8740
    1e7d:	0f 85 f1 02 00 00    	jne    2174 <subdir+0x41c>
  close(fd);
    1e83:	89 1c 24             	mov    %ebx,(%esp)
    1e86:	e8 f4 1b 00 00       	call   3a7f <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1e8b:	c7 44 24 04 ce 46 00 	movl   $0x46ce,0x4(%esp)
    1e92:	00 
    1e93:	c7 04 24 6a 46 00 00 	movl   $0x466a,(%esp)
    1e9a:	e8 18 1c 00 00       	call   3ab7 <link>
    1e9f:	85 c0                	test   %eax,%eax
    1ea1:	0f 85 c7 03 00 00    	jne    226e <subdir+0x516>
  if(unlink("dd/dd/ff") != 0){
    1ea7:	c7 04 24 6a 46 00 00 	movl   $0x466a,(%esp)
    1eae:	e8 f4 1b 00 00       	call   3aa7 <unlink>
    1eb3:	85 c0                	test   %eax,%eax
    1eb5:	0f 85 eb 02 00 00    	jne    21a6 <subdir+0x44e>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1ebb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1ec2:	00 
    1ec3:	c7 04 24 6a 46 00 00 	movl   $0x466a,(%esp)
    1eca:	e8 c8 1b 00 00       	call   3a97 <open>
    1ecf:	85 c0                	test   %eax,%eax
    1ed1:	0f 89 5f 04 00 00    	jns    2336 <subdir+0x5de>
  if(chdir("dd") != 0){
    1ed7:	c7 04 24 34 47 00 00 	movl   $0x4734,(%esp)
    1ede:	e8 e4 1b 00 00       	call   3ac7 <chdir>
    1ee3:	85 c0                	test   %eax,%eax
    1ee5:	0f 85 32 04 00 00    	jne    231d <subdir+0x5c5>
  if(chdir("dd/../../dd") != 0){
    1eeb:	c7 04 24 02 47 00 00 	movl   $0x4702,(%esp)
    1ef2:	e8 d0 1b 00 00       	call   3ac7 <chdir>
    1ef7:	85 c0                	test   %eax,%eax
    1ef9:	0f 85 8e 02 00 00    	jne    218d <subdir+0x435>
  if(chdir("dd/../../../dd") != 0){
    1eff:	c7 04 24 28 47 00 00 	movl   $0x4728,(%esp)
    1f06:	e8 bc 1b 00 00       	call   3ac7 <chdir>
    1f0b:	85 c0                	test   %eax,%eax
    1f0d:	0f 85 7a 02 00 00    	jne    218d <subdir+0x435>
  if(chdir("./..") != 0){
    1f13:	c7 04 24 37 47 00 00 	movl   $0x4737,(%esp)
    1f1a:	e8 a8 1b 00 00       	call   3ac7 <chdir>
    1f1f:	85 c0                	test   %eax,%eax
    1f21:	0f 85 2e 03 00 00    	jne    2255 <subdir+0x4fd>
  fd = open("dd/dd/ffff", 0);
    1f27:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1f2e:	00 
    1f2f:	c7 04 24 ce 46 00 00 	movl   $0x46ce,(%esp)
    1f36:	e8 5c 1b 00 00       	call   3a97 <open>
    1f3b:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1f3d:	85 c0                	test   %eax,%eax
    1f3f:	0f 88 81 05 00 00    	js     24c6 <subdir+0x76e>
  if(read(fd, buf, sizeof(buf)) != 2){
    1f45:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1f4c:	00 
    1f4d:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
    1f54:	00 
    1f55:	89 04 24             	mov    %eax,(%esp)
    1f58:	e8 12 1b 00 00       	call   3a6f <read>
    1f5d:	83 f8 02             	cmp    $0x2,%eax
    1f60:	0f 85 47 05 00 00    	jne    24ad <subdir+0x755>
  close(fd);
    1f66:	89 1c 24             	mov    %ebx,(%esp)
    1f69:	e8 11 1b 00 00       	call   3a7f <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1f6e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1f75:	00 
    1f76:	c7 04 24 6a 46 00 00 	movl   $0x466a,(%esp)
    1f7d:	e8 15 1b 00 00       	call   3a97 <open>
    1f82:	85 c0                	test   %eax,%eax
    1f84:	0f 89 4e 02 00 00    	jns    21d8 <subdir+0x480>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1f8a:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1f91:	00 
    1f92:	c7 04 24 82 47 00 00 	movl   $0x4782,(%esp)
    1f99:	e8 f9 1a 00 00       	call   3a97 <open>
    1f9e:	85 c0                	test   %eax,%eax
    1fa0:	0f 89 19 02 00 00    	jns    21bf <subdir+0x467>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1fa6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1fad:	00 
    1fae:	c7 04 24 a7 47 00 00 	movl   $0x47a7,(%esp)
    1fb5:	e8 dd 1a 00 00       	call   3a97 <open>
    1fba:	85 c0                	test   %eax,%eax
    1fbc:	0f 89 42 03 00 00    	jns    2304 <subdir+0x5ac>
  if(open("dd", O_CREATE) >= 0){
    1fc2:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1fc9:	00 
    1fca:	c7 04 24 34 47 00 00 	movl   $0x4734,(%esp)
    1fd1:	e8 c1 1a 00 00       	call   3a97 <open>
    1fd6:	85 c0                	test   %eax,%eax
    1fd8:	0f 89 0d 03 00 00    	jns    22eb <subdir+0x593>
  if(open("dd", O_RDWR) >= 0){
    1fde:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1fe5:	00 
    1fe6:	c7 04 24 34 47 00 00 	movl   $0x4734,(%esp)
    1fed:	e8 a5 1a 00 00       	call   3a97 <open>
    1ff2:	85 c0                	test   %eax,%eax
    1ff4:	0f 89 d8 02 00 00    	jns    22d2 <subdir+0x57a>
  if(open("dd", O_WRONLY) >= 0){
    1ffa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    2001:	00 
    2002:	c7 04 24 34 47 00 00 	movl   $0x4734,(%esp)
    2009:	e8 89 1a 00 00       	call   3a97 <open>
    200e:	85 c0                	test   %eax,%eax
    2010:	0f 89 a3 02 00 00    	jns    22b9 <subdir+0x561>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2016:	c7 44 24 04 16 48 00 	movl   $0x4816,0x4(%esp)
    201d:	00 
    201e:	c7 04 24 82 47 00 00 	movl   $0x4782,(%esp)
    2025:	e8 8d 1a 00 00       	call   3ab7 <link>
    202a:	85 c0                	test   %eax,%eax
    202c:	0f 84 6e 02 00 00    	je     22a0 <subdir+0x548>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2032:	c7 44 24 04 16 48 00 	movl   $0x4816,0x4(%esp)
    2039:	00 
    203a:	c7 04 24 a7 47 00 00 	movl   $0x47a7,(%esp)
    2041:	e8 71 1a 00 00       	call   3ab7 <link>
    2046:	85 c0                	test   %eax,%eax
    2048:	0f 84 39 02 00 00    	je     2287 <subdir+0x52f>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    204e:	c7 44 24 04 ce 46 00 	movl   $0x46ce,0x4(%esp)
    2055:	00 
    2056:	c7 04 24 6d 46 00 00 	movl   $0x466d,(%esp)
    205d:	e8 55 1a 00 00       	call   3ab7 <link>
    2062:	85 c0                	test   %eax,%eax
    2064:	0f 84 a0 01 00 00    	je     220a <subdir+0x4b2>
  if(mkdir("dd/ff/ff") == 0){
    206a:	c7 04 24 82 47 00 00 	movl   $0x4782,(%esp)
    2071:	e8 49 1a 00 00       	call   3abf <mkdir>
    2076:	85 c0                	test   %eax,%eax
    2078:	0f 84 73 01 00 00    	je     21f1 <subdir+0x499>
  if(mkdir("dd/xx/ff") == 0){
    207e:	c7 04 24 a7 47 00 00 	movl   $0x47a7,(%esp)
    2085:	e8 35 1a 00 00       	call   3abf <mkdir>
    208a:	85 c0                	test   %eax,%eax
    208c:	0f 84 02 04 00 00    	je     2494 <subdir+0x73c>
  if(mkdir("dd/dd/ffff") == 0){
    2092:	c7 04 24 ce 46 00 00 	movl   $0x46ce,(%esp)
    2099:	e8 21 1a 00 00       	call   3abf <mkdir>
    209e:	85 c0                	test   %eax,%eax
    20a0:	0f 84 d5 03 00 00    	je     247b <subdir+0x723>
  if(unlink("dd/xx/ff") == 0){
    20a6:	c7 04 24 a7 47 00 00 	movl   $0x47a7,(%esp)
    20ad:	e8 f5 19 00 00       	call   3aa7 <unlink>
    20b2:	85 c0                	test   %eax,%eax
    20b4:	0f 84 a8 03 00 00    	je     2462 <subdir+0x70a>
  if(unlink("dd/ff/ff") == 0){
    20ba:	c7 04 24 82 47 00 00 	movl   $0x4782,(%esp)
    20c1:	e8 e1 19 00 00       	call   3aa7 <unlink>
    20c6:	85 c0                	test   %eax,%eax
    20c8:	0f 84 7b 03 00 00    	je     2449 <subdir+0x6f1>
  if(chdir("dd/ff") == 0){
    20ce:	c7 04 24 6d 46 00 00 	movl   $0x466d,(%esp)
    20d5:	e8 ed 19 00 00       	call   3ac7 <chdir>
    20da:	85 c0                	test   %eax,%eax
    20dc:	0f 84 4e 03 00 00    	je     2430 <subdir+0x6d8>
  if(chdir("dd/xx") == 0){
    20e2:	c7 04 24 19 48 00 00 	movl   $0x4819,(%esp)
    20e9:	e8 d9 19 00 00       	call   3ac7 <chdir>
    20ee:	85 c0                	test   %eax,%eax
    20f0:	0f 84 21 03 00 00    	je     2417 <subdir+0x6bf>
  if(unlink("dd/dd/ffff") != 0){
    20f6:	c7 04 24 ce 46 00 00 	movl   $0x46ce,(%esp)
    20fd:	e8 a5 19 00 00       	call   3aa7 <unlink>
    2102:	85 c0                	test   %eax,%eax
    2104:	0f 85 9c 00 00 00    	jne    21a6 <subdir+0x44e>
  if(unlink("dd/ff") != 0){
    210a:	c7 04 24 6d 46 00 00 	movl   $0x466d,(%esp)
    2111:	e8 91 19 00 00       	call   3aa7 <unlink>
    2116:	85 c0                	test   %eax,%eax
    2118:	0f 85 e0 02 00 00    	jne    23fe <subdir+0x6a6>
  if(unlink("dd") == 0){
    211e:	c7 04 24 34 47 00 00 	movl   $0x4734,(%esp)
    2125:	e8 7d 19 00 00       	call   3aa7 <unlink>
    212a:	85 c0                	test   %eax,%eax
    212c:	0f 84 b3 02 00 00    	je     23e5 <subdir+0x68d>
  if(unlink("dd/dd") < 0){
    2132:	c7 04 24 49 46 00 00 	movl   $0x4649,(%esp)
    2139:	e8 69 19 00 00       	call   3aa7 <unlink>
    213e:	85 c0                	test   %eax,%eax
    2140:	0f 88 86 02 00 00    	js     23cc <subdir+0x674>
  if(unlink("dd") < 0){
    2146:	c7 04 24 34 47 00 00 	movl   $0x4734,(%esp)
    214d:	e8 55 19 00 00       	call   3aa7 <unlink>
    2152:	85 c0                	test   %eax,%eax
    2154:	0f 88 59 02 00 00    	js     23b3 <subdir+0x65b>
  printf(1, "subdir ok\n");
    215a:	c7 44 24 04 16 49 00 	movl   $0x4916,0x4(%esp)
    2161:	00 
    2162:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2169:	e8 32 1a 00 00       	call   3ba0 <printf>
}
    216e:	83 c4 14             	add    $0x14,%esp
    2171:	5b                   	pop    %ebx
    2172:	5d                   	pop    %ebp
    2173:	c3                   	ret    
    printf(1, "dd/dd/../ff wrong content\n");
    2174:	c7 44 24 04 b3 46 00 	movl   $0x46b3,0x4(%esp)
    217b:	00 
    217c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2183:	e8 18 1a 00 00       	call   3ba0 <printf>
    exit();
    2188:	e8 ca 18 00 00       	call   3a57 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    218d:	c7 44 24 04 0e 47 00 	movl   $0x470e,0x4(%esp)
    2194:	00 
    2195:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    219c:	e8 ff 19 00 00       	call   3ba0 <printf>
    exit();
    21a1:	e8 b1 18 00 00       	call   3a57 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    21a6:	c7 44 24 04 d9 46 00 	movl   $0x46d9,0x4(%esp)
    21ad:	00 
    21ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21b5:	e8 e6 19 00 00       	call   3ba0 <printf>
    exit();
    21ba:	e8 98 18 00 00       	call   3a57 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    21bf:	c7 44 24 04 8b 47 00 	movl   $0x478b,0x4(%esp)
    21c6:	00 
    21c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21ce:	e8 cd 19 00 00       	call   3ba0 <printf>
    exit();
    21d3:	e8 7f 18 00 00       	call   3a57 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    21d8:	c7 44 24 04 70 51 00 	movl   $0x5170,0x4(%esp)
    21df:	00 
    21e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21e7:	e8 b4 19 00 00       	call   3ba0 <printf>
    exit();
    21ec:	e8 66 18 00 00       	call   3a57 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    21f1:	c7 44 24 04 1f 48 00 	movl   $0x481f,0x4(%esp)
    21f8:	00 
    21f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2200:	e8 9b 19 00 00       	call   3ba0 <printf>
    exit();
    2205:	e8 4d 18 00 00       	call   3a57 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    220a:	c7 44 24 04 e0 51 00 	movl   $0x51e0,0x4(%esp)
    2211:	00 
    2212:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2219:	e8 82 19 00 00       	call   3ba0 <printf>
    exit();
    221e:	e8 34 18 00 00       	call   3a57 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    2223:	c7 44 24 04 9a 46 00 	movl   $0x469a,0x4(%esp)
    222a:	00 
    222b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2232:	e8 69 19 00 00       	call   3ba0 <printf>
    exit();
    2237:	e8 1b 18 00 00       	call   3a57 <exit>
    printf(1, "create dd/dd/ff failed\n");
    223c:	c7 44 24 04 73 46 00 	movl   $0x4673,0x4(%esp)
    2243:	00 
    2244:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    224b:	e8 50 19 00 00       	call   3ba0 <printf>
    exit();
    2250:	e8 02 18 00 00       	call   3a57 <exit>
    printf(1, "chdir ./.. failed\n");
    2255:	c7 44 24 04 3c 47 00 	movl   $0x473c,0x4(%esp)
    225c:	00 
    225d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2264:	e8 37 19 00 00       	call   3ba0 <printf>
    exit();
    2269:	e8 e9 17 00 00       	call   3a57 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    226e:	c7 44 24 04 28 51 00 	movl   $0x5128,0x4(%esp)
    2275:	00 
    2276:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    227d:	e8 1e 19 00 00       	call   3ba0 <printf>
    exit();
    2282:	e8 d0 17 00 00       	call   3a57 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2287:	c7 44 24 04 bc 51 00 	movl   $0x51bc,0x4(%esp)
    228e:	00 
    228f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2296:	e8 05 19 00 00       	call   3ba0 <printf>
    exit();
    229b:	e8 b7 17 00 00       	call   3a57 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    22a0:	c7 44 24 04 98 51 00 	movl   $0x5198,0x4(%esp)
    22a7:	00 
    22a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22af:	e8 ec 18 00 00       	call   3ba0 <printf>
    exit();
    22b4:	e8 9e 17 00 00       	call   3a57 <exit>
    printf(1, "open dd wronly succeeded!\n");
    22b9:	c7 44 24 04 fb 47 00 	movl   $0x47fb,0x4(%esp)
    22c0:	00 
    22c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22c8:	e8 d3 18 00 00       	call   3ba0 <printf>
    exit();
    22cd:	e8 85 17 00 00       	call   3a57 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    22d2:	c7 44 24 04 e2 47 00 	movl   $0x47e2,0x4(%esp)
    22d9:	00 
    22da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22e1:	e8 ba 18 00 00       	call   3ba0 <printf>
    exit();
    22e6:	e8 6c 17 00 00       	call   3a57 <exit>
    printf(1, "create dd succeeded!\n");
    22eb:	c7 44 24 04 cc 47 00 	movl   $0x47cc,0x4(%esp)
    22f2:	00 
    22f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22fa:	e8 a1 18 00 00       	call   3ba0 <printf>
    exit();
    22ff:	e8 53 17 00 00       	call   3a57 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    2304:	c7 44 24 04 b0 47 00 	movl   $0x47b0,0x4(%esp)
    230b:	00 
    230c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2313:	e8 88 18 00 00       	call   3ba0 <printf>
    exit();
    2318:	e8 3a 17 00 00       	call   3a57 <exit>
    printf(1, "chdir dd failed\n");
    231d:	c7 44 24 04 f1 46 00 	movl   $0x46f1,0x4(%esp)
    2324:	00 
    2325:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    232c:	e8 6f 18 00 00       	call   3ba0 <printf>
    exit();
    2331:	e8 21 17 00 00       	call   3a57 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2336:	c7 44 24 04 4c 51 00 	movl   $0x514c,0x4(%esp)
    233d:	00 
    233e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2345:	e8 56 18 00 00       	call   3ba0 <printf>
    exit();
    234a:	e8 08 17 00 00       	call   3a57 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    234f:	c7 44 24 04 4f 46 00 	movl   $0x464f,0x4(%esp)
    2356:	00 
    2357:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    235e:	e8 3d 18 00 00       	call   3ba0 <printf>
    exit();
    2363:	e8 ef 16 00 00       	call   3a57 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2368:	c7 44 24 04 00 51 00 	movl   $0x5100,0x4(%esp)
    236f:	00 
    2370:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2377:	e8 24 18 00 00       	call   3ba0 <printf>
    exit();
    237c:	e8 d6 16 00 00       	call   3a57 <exit>
    printf(1, "create dd/ff failed\n");
    2381:	c7 44 24 04 33 46 00 	movl   $0x4633,0x4(%esp)
    2388:	00 
    2389:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2390:	e8 0b 18 00 00       	call   3ba0 <printf>
    exit();
    2395:	e8 bd 16 00 00       	call   3a57 <exit>
    printf(1, "subdir mkdir dd failed\n");
    239a:	c7 44 24 04 1b 46 00 	movl   $0x461b,0x4(%esp)
    23a1:	00 
    23a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23a9:	e8 f2 17 00 00       	call   3ba0 <printf>
    exit();
    23ae:	e8 a4 16 00 00       	call   3a57 <exit>
    printf(1, "unlink dd failed\n");
    23b3:	c7 44 24 04 04 49 00 	movl   $0x4904,0x4(%esp)
    23ba:	00 
    23bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23c2:	e8 d9 17 00 00       	call   3ba0 <printf>
    exit();
    23c7:	e8 8b 16 00 00       	call   3a57 <exit>
    printf(1, "unlink dd/dd failed\n");
    23cc:	c7 44 24 04 ef 48 00 	movl   $0x48ef,0x4(%esp)
    23d3:	00 
    23d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23db:	e8 c0 17 00 00       	call   3ba0 <printf>
    exit();
    23e0:	e8 72 16 00 00       	call   3a57 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    23e5:	c7 44 24 04 04 52 00 	movl   $0x5204,0x4(%esp)
    23ec:	00 
    23ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23f4:	e8 a7 17 00 00       	call   3ba0 <printf>
    exit();
    23f9:	e8 59 16 00 00       	call   3a57 <exit>
    printf(1, "unlink dd/ff failed\n");
    23fe:	c7 44 24 04 da 48 00 	movl   $0x48da,0x4(%esp)
    2405:	00 
    2406:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    240d:	e8 8e 17 00 00       	call   3ba0 <printf>
    exit();
    2412:	e8 40 16 00 00       	call   3a57 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    2417:	c7 44 24 04 c2 48 00 	movl   $0x48c2,0x4(%esp)
    241e:	00 
    241f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2426:	e8 75 17 00 00       	call   3ba0 <printf>
    exit();
    242b:	e8 27 16 00 00       	call   3a57 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    2430:	c7 44 24 04 aa 48 00 	movl   $0x48aa,0x4(%esp)
    2437:	00 
    2438:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    243f:	e8 5c 17 00 00       	call   3ba0 <printf>
    exit();
    2444:	e8 0e 16 00 00       	call   3a57 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2449:	c7 44 24 04 8e 48 00 	movl   $0x488e,0x4(%esp)
    2450:	00 
    2451:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2458:	e8 43 17 00 00       	call   3ba0 <printf>
    exit();
    245d:	e8 f5 15 00 00       	call   3a57 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2462:	c7 44 24 04 72 48 00 	movl   $0x4872,0x4(%esp)
    2469:	00 
    246a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2471:	e8 2a 17 00 00       	call   3ba0 <printf>
    exit();
    2476:	e8 dc 15 00 00       	call   3a57 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    247b:	c7 44 24 04 55 48 00 	movl   $0x4855,0x4(%esp)
    2482:	00 
    2483:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    248a:	e8 11 17 00 00       	call   3ba0 <printf>
    exit();
    248f:	e8 c3 15 00 00       	call   3a57 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2494:	c7 44 24 04 3a 48 00 	movl   $0x483a,0x4(%esp)
    249b:	00 
    249c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24a3:	e8 f8 16 00 00       	call   3ba0 <printf>
    exit();
    24a8:	e8 aa 15 00 00       	call   3a57 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    24ad:	c7 44 24 04 67 47 00 	movl   $0x4767,0x4(%esp)
    24b4:	00 
    24b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24bc:	e8 df 16 00 00       	call   3ba0 <printf>
    exit();
    24c1:	e8 91 15 00 00       	call   3a57 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    24c6:	c7 44 24 04 4f 47 00 	movl   $0x474f,0x4(%esp)
    24cd:	00 
    24ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24d5:	e8 c6 16 00 00       	call   3ba0 <printf>
    exit();
    24da:	e8 78 15 00 00       	call   3a57 <exit>
    24df:	90                   	nop

000024e0 <bigwrite>:
{
    24e0:	55                   	push   %ebp
    24e1:	89 e5                	mov    %esp,%ebp
    24e3:	56                   	push   %esi
    24e4:	53                   	push   %ebx
    24e5:	83 ec 10             	sub    $0x10,%esp
  printf(1, "bigwrite test\n");
    24e8:	c7 44 24 04 21 49 00 	movl   $0x4921,0x4(%esp)
    24ef:	00 
    24f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24f7:	e8 a4 16 00 00       	call   3ba0 <printf>
  unlink("bigwrite");
    24fc:	c7 04 24 30 49 00 00 	movl   $0x4930,(%esp)
    2503:	e8 9f 15 00 00       	call   3aa7 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    2508:	bb f3 01 00 00       	mov    $0x1f3,%ebx
    250d:	8d 76 00             	lea    0x0(%esi),%esi
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2510:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2517:	00 
    2518:	c7 04 24 30 49 00 00 	movl   $0x4930,(%esp)
    251f:	e8 73 15 00 00       	call   3a97 <open>
    2524:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    2526:	85 c0                	test   %eax,%eax
    2528:	0f 88 8e 00 00 00    	js     25bc <bigwrite+0xdc>
      int cc = write(fd, buf, sz);
    252e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    2532:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
    2539:	00 
    253a:	89 04 24             	mov    %eax,(%esp)
    253d:	e8 35 15 00 00       	call   3a77 <write>
      if(cc != sz){
    2542:	39 d8                	cmp    %ebx,%eax
    2544:	75 55                	jne    259b <bigwrite+0xbb>
      int cc = write(fd, buf, sz);
    2546:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    254a:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
    2551:	00 
    2552:	89 34 24             	mov    %esi,(%esp)
    2555:	e8 1d 15 00 00       	call   3a77 <write>
      if(cc != sz){
    255a:	39 c3                	cmp    %eax,%ebx
    255c:	75 3d                	jne    259b <bigwrite+0xbb>
    close(fd);
    255e:	89 34 24             	mov    %esi,(%esp)
    2561:	e8 19 15 00 00       	call   3a7f <close>
    unlink("bigwrite");
    2566:	c7 04 24 30 49 00 00 	movl   $0x4930,(%esp)
    256d:	e8 35 15 00 00       	call   3aa7 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    2572:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    2578:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    257e:	75 90                	jne    2510 <bigwrite+0x30>
  printf(1, "bigwrite ok\n");
    2580:	c7 44 24 04 63 49 00 	movl   $0x4963,0x4(%esp)
    2587:	00 
    2588:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    258f:	e8 0c 16 00 00       	call   3ba0 <printf>
}
    2594:	83 c4 10             	add    $0x10,%esp
    2597:	5b                   	pop    %ebx
    2598:	5e                   	pop    %esi
    2599:	5d                   	pop    %ebp
    259a:	c3                   	ret    
        printf(1, "write(%d) ret %d\n", sz, cc);
    259b:	89 44 24 0c          	mov    %eax,0xc(%esp)
    259f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    25a3:	c7 44 24 04 51 49 00 	movl   $0x4951,0x4(%esp)
    25aa:	00 
    25ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25b2:	e8 e9 15 00 00       	call   3ba0 <printf>
        exit();
    25b7:	e8 9b 14 00 00       	call   3a57 <exit>
      printf(1, "cannot create bigwrite\n");
    25bc:	c7 44 24 04 39 49 00 	movl   $0x4939,0x4(%esp)
    25c3:	00 
    25c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25cb:	e8 d0 15 00 00       	call   3ba0 <printf>
      exit();
    25d0:	e8 82 14 00 00       	call   3a57 <exit>
    25d5:	8d 76 00             	lea    0x0(%esi),%esi

000025d8 <bigfile>:
{
    25d8:	55                   	push   %ebp
    25d9:	89 e5                	mov    %esp,%ebp
    25db:	57                   	push   %edi
    25dc:	56                   	push   %esi
    25dd:	53                   	push   %ebx
    25de:	83 ec 1c             	sub    $0x1c,%esp
  printf(1, "bigfile test\n");
    25e1:	c7 44 24 04 70 49 00 	movl   $0x4970,0x4(%esp)
    25e8:	00 
    25e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25f0:	e8 ab 15 00 00       	call   3ba0 <printf>
  unlink("bigfile");
    25f5:	c7 04 24 8c 49 00 00 	movl   $0x498c,(%esp)
    25fc:	e8 a6 14 00 00       	call   3aa7 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2601:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2608:	00 
    2609:	c7 04 24 8c 49 00 00 	movl   $0x498c,(%esp)
    2610:	e8 82 14 00 00       	call   3a97 <open>
    2615:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    2617:	85 c0                	test   %eax,%eax
    2619:	0f 88 79 01 00 00    	js     2798 <bigfile+0x1c0>
    261f:	31 db                	xor    %ebx,%ebx
    2621:	8d 76 00             	lea    0x0(%esi),%esi
    memset(buf, i, 600);
    2624:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    262b:	00 
    262c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    2630:	c7 04 24 40 87 00 00 	movl   $0x8740,(%esp)
    2637:	e8 c8 12 00 00       	call   3904 <memset>
    if(write(fd, buf, 600) != 600){
    263c:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    2643:	00 
    2644:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
    264b:	00 
    264c:	89 34 24             	mov    %esi,(%esp)
    264f:	e8 23 14 00 00       	call   3a77 <write>
    2654:	3d 58 02 00 00       	cmp    $0x258,%eax
    2659:	0f 85 07 01 00 00    	jne    2766 <bigfile+0x18e>
  for(i = 0; i < 20; i++){
    265f:	43                   	inc    %ebx
    2660:	83 fb 14             	cmp    $0x14,%ebx
    2663:	75 bf                	jne    2624 <bigfile+0x4c>
  close(fd);
    2665:	89 34 24             	mov    %esi,(%esp)
    2668:	e8 12 14 00 00       	call   3a7f <close>
  fd = open("bigfile", 0);
    266d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2674:	00 
    2675:	c7 04 24 8c 49 00 00 	movl   $0x498c,(%esp)
    267c:	e8 16 14 00 00       	call   3a97 <open>
    2681:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    2683:	85 c0                	test   %eax,%eax
    2685:	0f 88 f4 00 00 00    	js     277f <bigfile+0x1a7>
    268b:	31 f6                	xor    %esi,%esi
    268d:	31 db                	xor    %ebx,%ebx
    268f:	eb 2f                	jmp    26c0 <bigfile+0xe8>
    2691:	8d 76 00             	lea    0x0(%esi),%esi
    if(cc != 300){
    2694:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    2699:	0f 85 95 00 00 00    	jne    2734 <bigfile+0x15c>
    if(buf[0] != i/2 || buf[299] != i/2){
    269f:	0f be 05 40 87 00 00 	movsbl 0x8740,%eax
    26a6:	89 da                	mov    %ebx,%edx
    26a8:	d1 fa                	sar    %edx
    26aa:	39 d0                	cmp    %edx,%eax
    26ac:	75 6d                	jne    271b <bigfile+0x143>
    26ae:	0f be 15 6b 88 00 00 	movsbl 0x886b,%edx
    26b5:	39 d0                	cmp    %edx,%eax
    26b7:	75 62                	jne    271b <bigfile+0x143>
    total += cc;
    26b9:	81 c6 2c 01 00 00    	add    $0x12c,%esi
  for(i = 0; ; i++){
    26bf:	43                   	inc    %ebx
    cc = read(fd, buf, 300);
    26c0:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    26c7:	00 
    26c8:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
    26cf:	00 
    26d0:	89 3c 24             	mov    %edi,(%esp)
    26d3:	e8 97 13 00 00       	call   3a6f <read>
    if(cc < 0){
    26d8:	83 f8 00             	cmp    $0x0,%eax
    26db:	7c 70                	jl     274d <bigfile+0x175>
    if(cc == 0)
    26dd:	75 b5                	jne    2694 <bigfile+0xbc>
  close(fd);
    26df:	89 3c 24             	mov    %edi,(%esp)
    26e2:	e8 98 13 00 00       	call   3a7f <close>
  if(total != 20*600){
    26e7:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
    26ed:	0f 85 be 00 00 00    	jne    27b1 <bigfile+0x1d9>
  unlink("bigfile");
    26f3:	c7 04 24 8c 49 00 00 	movl   $0x498c,(%esp)
    26fa:	e8 a8 13 00 00       	call   3aa7 <unlink>
  printf(1, "bigfile test ok\n");
    26ff:	c7 44 24 04 1b 4a 00 	movl   $0x4a1b,0x4(%esp)
    2706:	00 
    2707:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    270e:	e8 8d 14 00 00       	call   3ba0 <printf>
}
    2713:	83 c4 1c             	add    $0x1c,%esp
    2716:	5b                   	pop    %ebx
    2717:	5e                   	pop    %esi
    2718:	5f                   	pop    %edi
    2719:	5d                   	pop    %ebp
    271a:	c3                   	ret    
      printf(1, "read bigfile wrong data\n");
    271b:	c7 44 24 04 e8 49 00 	movl   $0x49e8,0x4(%esp)
    2722:	00 
    2723:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    272a:	e8 71 14 00 00       	call   3ba0 <printf>
      exit();
    272f:	e8 23 13 00 00       	call   3a57 <exit>
      printf(1, "short read bigfile\n");
    2734:	c7 44 24 04 d4 49 00 	movl   $0x49d4,0x4(%esp)
    273b:	00 
    273c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2743:	e8 58 14 00 00       	call   3ba0 <printf>
      exit();
    2748:	e8 0a 13 00 00       	call   3a57 <exit>
      printf(1, "read bigfile failed\n");
    274d:	c7 44 24 04 bf 49 00 	movl   $0x49bf,0x4(%esp)
    2754:	00 
    2755:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    275c:	e8 3f 14 00 00       	call   3ba0 <printf>
      exit();
    2761:	e8 f1 12 00 00       	call   3a57 <exit>
      printf(1, "write bigfile failed\n");
    2766:	c7 44 24 04 94 49 00 	movl   $0x4994,0x4(%esp)
    276d:	00 
    276e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2775:	e8 26 14 00 00       	call   3ba0 <printf>
      exit();
    277a:	e8 d8 12 00 00       	call   3a57 <exit>
    printf(1, "cannot open bigfile\n");
    277f:	c7 44 24 04 aa 49 00 	movl   $0x49aa,0x4(%esp)
    2786:	00 
    2787:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    278e:	e8 0d 14 00 00       	call   3ba0 <printf>
    exit();
    2793:	e8 bf 12 00 00       	call   3a57 <exit>
    printf(1, "cannot create bigfile");
    2798:	c7 44 24 04 7e 49 00 	movl   $0x497e,0x4(%esp)
    279f:	00 
    27a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27a7:	e8 f4 13 00 00       	call   3ba0 <printf>
    exit();
    27ac:	e8 a6 12 00 00       	call   3a57 <exit>
    printf(1, "read bigfile wrong total\n");
    27b1:	c7 44 24 04 01 4a 00 	movl   $0x4a01,0x4(%esp)
    27b8:	00 
    27b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27c0:	e8 db 13 00 00       	call   3ba0 <printf>
    exit();
    27c5:	e8 8d 12 00 00       	call   3a57 <exit>
    27ca:	66 90                	xchg   %ax,%ax

000027cc <fourteen>:
{
    27cc:	55                   	push   %ebp
    27cd:	89 e5                	mov    %esp,%ebp
    27cf:	83 ec 18             	sub    $0x18,%esp
  printf(1, "fourteen test\n");
    27d2:	c7 44 24 04 2c 4a 00 	movl   $0x4a2c,0x4(%esp)
    27d9:	00 
    27da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27e1:	e8 ba 13 00 00       	call   3ba0 <printf>
  if(mkdir("12345678901234") != 0){
    27e6:	c7 04 24 67 4a 00 00 	movl   $0x4a67,(%esp)
    27ed:	e8 cd 12 00 00       	call   3abf <mkdir>
    27f2:	85 c0                	test   %eax,%eax
    27f4:	0f 85 92 00 00 00    	jne    288c <fourteen+0xc0>
  if(mkdir("12345678901234/123456789012345") != 0){
    27fa:	c7 04 24 24 52 00 00 	movl   $0x5224,(%esp)
    2801:	e8 b9 12 00 00       	call   3abf <mkdir>
    2806:	85 c0                	test   %eax,%eax
    2808:	0f 85 fb 00 00 00    	jne    2909 <fourteen+0x13d>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    280e:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2815:	00 
    2816:	c7 04 24 74 52 00 00 	movl   $0x5274,(%esp)
    281d:	e8 75 12 00 00       	call   3a97 <open>
  if(fd < 0){
    2822:	85 c0                	test   %eax,%eax
    2824:	0f 88 c6 00 00 00    	js     28f0 <fourteen+0x124>
  close(fd);
    282a:	89 04 24             	mov    %eax,(%esp)
    282d:	e8 4d 12 00 00       	call   3a7f <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2832:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2839:	00 
    283a:	c7 04 24 e4 52 00 00 	movl   $0x52e4,(%esp)
    2841:	e8 51 12 00 00       	call   3a97 <open>
  if(fd < 0){
    2846:	85 c0                	test   %eax,%eax
    2848:	0f 88 89 00 00 00    	js     28d7 <fourteen+0x10b>
  close(fd);
    284e:	89 04 24             	mov    %eax,(%esp)
    2851:	e8 29 12 00 00       	call   3a7f <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2856:	c7 04 24 58 4a 00 00 	movl   $0x4a58,(%esp)
    285d:	e8 5d 12 00 00       	call   3abf <mkdir>
    2862:	85 c0                	test   %eax,%eax
    2864:	74 58                	je     28be <fourteen+0xf2>
  if(mkdir("123456789012345/12345678901234") == 0){
    2866:	c7 04 24 80 53 00 00 	movl   $0x5380,(%esp)
    286d:	e8 4d 12 00 00       	call   3abf <mkdir>
    2872:	85 c0                	test   %eax,%eax
    2874:	74 2f                	je     28a5 <fourteen+0xd9>
  printf(1, "fourteen ok\n");
    2876:	c7 44 24 04 76 4a 00 	movl   $0x4a76,0x4(%esp)
    287d:	00 
    287e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2885:	e8 16 13 00 00       	call   3ba0 <printf>
}
    288a:	c9                   	leave  
    288b:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    288c:	c7 44 24 04 3b 4a 00 	movl   $0x4a3b,0x4(%esp)
    2893:	00 
    2894:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    289b:	e8 00 13 00 00       	call   3ba0 <printf>
    exit();
    28a0:	e8 b2 11 00 00       	call   3a57 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    28a5:	c7 44 24 04 a0 53 00 	movl   $0x53a0,0x4(%esp)
    28ac:	00 
    28ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28b4:	e8 e7 12 00 00       	call   3ba0 <printf>
    exit();
    28b9:	e8 99 11 00 00       	call   3a57 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    28be:	c7 44 24 04 50 53 00 	movl   $0x5350,0x4(%esp)
    28c5:	00 
    28c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28cd:	e8 ce 12 00 00       	call   3ba0 <printf>
    exit();
    28d2:	e8 80 11 00 00       	call   3a57 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    28d7:	c7 44 24 04 14 53 00 	movl   $0x5314,0x4(%esp)
    28de:	00 
    28df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28e6:	e8 b5 12 00 00       	call   3ba0 <printf>
    exit();
    28eb:	e8 67 11 00 00       	call   3a57 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    28f0:	c7 44 24 04 a4 52 00 	movl   $0x52a4,0x4(%esp)
    28f7:	00 
    28f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28ff:	e8 9c 12 00 00       	call   3ba0 <printf>
    exit();
    2904:	e8 4e 11 00 00       	call   3a57 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2909:	c7 44 24 04 44 52 00 	movl   $0x5244,0x4(%esp)
    2910:	00 
    2911:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2918:	e8 83 12 00 00       	call   3ba0 <printf>
    exit();
    291d:	e8 35 11 00 00       	call   3a57 <exit>
    2922:	66 90                	xchg   %ax,%ax

00002924 <rmdot>:
{
    2924:	55                   	push   %ebp
    2925:	89 e5                	mov    %esp,%ebp
    2927:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    292a:	c7 44 24 04 83 4a 00 	movl   $0x4a83,0x4(%esp)
    2931:	00 
    2932:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2939:	e8 62 12 00 00       	call   3ba0 <printf>
  if(mkdir("dots") != 0){
    293e:	c7 04 24 8f 4a 00 00 	movl   $0x4a8f,(%esp)
    2945:	e8 75 11 00 00       	call   3abf <mkdir>
    294a:	85 c0                	test   %eax,%eax
    294c:	0f 85 9a 00 00 00    	jne    29ec <rmdot+0xc8>
  if(chdir("dots") != 0){
    2952:	c7 04 24 8f 4a 00 00 	movl   $0x4a8f,(%esp)
    2959:	e8 69 11 00 00       	call   3ac7 <chdir>
    295e:	85 c0                	test   %eax,%eax
    2960:	0f 85 35 01 00 00    	jne    2a9b <rmdot+0x177>
  if(unlink(".") == 0){
    2966:	c7 04 24 3a 47 00 00 	movl   $0x473a,(%esp)
    296d:	e8 35 11 00 00       	call   3aa7 <unlink>
    2972:	85 c0                	test   %eax,%eax
    2974:	0f 84 08 01 00 00    	je     2a82 <rmdot+0x15e>
  if(unlink("..") == 0){
    297a:	c7 04 24 39 47 00 00 	movl   $0x4739,(%esp)
    2981:	e8 21 11 00 00       	call   3aa7 <unlink>
    2986:	85 c0                	test   %eax,%eax
    2988:	0f 84 db 00 00 00    	je     2a69 <rmdot+0x145>
  if(chdir("/") != 0){
    298e:	c7 04 24 0d 3f 00 00 	movl   $0x3f0d,(%esp)
    2995:	e8 2d 11 00 00       	call   3ac7 <chdir>
    299a:	85 c0                	test   %eax,%eax
    299c:	0f 85 ae 00 00 00    	jne    2a50 <rmdot+0x12c>
  if(unlink("dots/.") == 0){
    29a2:	c7 04 24 d7 4a 00 00 	movl   $0x4ad7,(%esp)
    29a9:	e8 f9 10 00 00       	call   3aa7 <unlink>
    29ae:	85 c0                	test   %eax,%eax
    29b0:	0f 84 81 00 00 00    	je     2a37 <rmdot+0x113>
  if(unlink("dots/..") == 0){
    29b6:	c7 04 24 f5 4a 00 00 	movl   $0x4af5,(%esp)
    29bd:	e8 e5 10 00 00       	call   3aa7 <unlink>
    29c2:	85 c0                	test   %eax,%eax
    29c4:	74 58                	je     2a1e <rmdot+0xfa>
  if(unlink("dots") != 0){
    29c6:	c7 04 24 8f 4a 00 00 	movl   $0x4a8f,(%esp)
    29cd:	e8 d5 10 00 00       	call   3aa7 <unlink>
    29d2:	85 c0                	test   %eax,%eax
    29d4:	75 2f                	jne    2a05 <rmdot+0xe1>
  printf(1, "rmdot ok\n");
    29d6:	c7 44 24 04 2a 4b 00 	movl   $0x4b2a,0x4(%esp)
    29dd:	00 
    29de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29e5:	e8 b6 11 00 00       	call   3ba0 <printf>
}
    29ea:	c9                   	leave  
    29eb:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    29ec:	c7 44 24 04 94 4a 00 	movl   $0x4a94,0x4(%esp)
    29f3:	00 
    29f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29fb:	e8 a0 11 00 00       	call   3ba0 <printf>
    exit();
    2a00:	e8 52 10 00 00       	call   3a57 <exit>
    printf(1, "unlink dots failed!\n");
    2a05:	c7 44 24 04 15 4b 00 	movl   $0x4b15,0x4(%esp)
    2a0c:	00 
    2a0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a14:	e8 87 11 00 00       	call   3ba0 <printf>
    exit();
    2a19:	e8 39 10 00 00       	call   3a57 <exit>
    printf(1, "unlink dots/.. worked!\n");
    2a1e:	c7 44 24 04 fd 4a 00 	movl   $0x4afd,0x4(%esp)
    2a25:	00 
    2a26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a2d:	e8 6e 11 00 00       	call   3ba0 <printf>
    exit();
    2a32:	e8 20 10 00 00       	call   3a57 <exit>
    printf(1, "unlink dots/. worked!\n");
    2a37:	c7 44 24 04 de 4a 00 	movl   $0x4ade,0x4(%esp)
    2a3e:	00 
    2a3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a46:	e8 55 11 00 00       	call   3ba0 <printf>
    exit();
    2a4b:	e8 07 10 00 00       	call   3a57 <exit>
    printf(1, "chdir / failed\n");
    2a50:	c7 44 24 04 0f 3f 00 	movl   $0x3f0f,0x4(%esp)
    2a57:	00 
    2a58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a5f:	e8 3c 11 00 00       	call   3ba0 <printf>
    exit();
    2a64:	e8 ee 0f 00 00       	call   3a57 <exit>
    printf(1, "rm .. worked!\n");
    2a69:	c7 44 24 04 c8 4a 00 	movl   $0x4ac8,0x4(%esp)
    2a70:	00 
    2a71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a78:	e8 23 11 00 00       	call   3ba0 <printf>
    exit();
    2a7d:	e8 d5 0f 00 00       	call   3a57 <exit>
    printf(1, "rm . worked!\n");
    2a82:	c7 44 24 04 ba 4a 00 	movl   $0x4aba,0x4(%esp)
    2a89:	00 
    2a8a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a91:	e8 0a 11 00 00       	call   3ba0 <printf>
    exit();
    2a96:	e8 bc 0f 00 00       	call   3a57 <exit>
    printf(1, "chdir dots failed\n");
    2a9b:	c7 44 24 04 a7 4a 00 	movl   $0x4aa7,0x4(%esp)
    2aa2:	00 
    2aa3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2aaa:	e8 f1 10 00 00       	call   3ba0 <printf>
    exit();
    2aaf:	e8 a3 0f 00 00       	call   3a57 <exit>

00002ab4 <dirfile>:
{
    2ab4:	55                   	push   %ebp
    2ab5:	89 e5                	mov    %esp,%ebp
    2ab7:	53                   	push   %ebx
    2ab8:	83 ec 14             	sub    $0x14,%esp
  printf(1, "dir vs file\n");
    2abb:	c7 44 24 04 34 4b 00 	movl   $0x4b34,0x4(%esp)
    2ac2:	00 
    2ac3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2aca:	e8 d1 10 00 00       	call   3ba0 <printf>
  fd = open("dirfile", O_CREATE);
    2acf:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2ad6:	00 
    2ad7:	c7 04 24 41 4b 00 00 	movl   $0x4b41,(%esp)
    2ade:	e8 b4 0f 00 00       	call   3a97 <open>
  if(fd < 0){
    2ae3:	85 c0                	test   %eax,%eax
    2ae5:	0f 88 4e 01 00 00    	js     2c39 <dirfile+0x185>
  close(fd);
    2aeb:	89 04 24             	mov    %eax,(%esp)
    2aee:	e8 8c 0f 00 00       	call   3a7f <close>
  if(chdir("dirfile") == 0){
    2af3:	c7 04 24 41 4b 00 00 	movl   $0x4b41,(%esp)
    2afa:	e8 c8 0f 00 00       	call   3ac7 <chdir>
    2aff:	85 c0                	test   %eax,%eax
    2b01:	0f 84 19 01 00 00    	je     2c20 <dirfile+0x16c>
  fd = open("dirfile/xx", 0);
    2b07:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2b0e:	00 
    2b0f:	c7 04 24 7a 4b 00 00 	movl   $0x4b7a,(%esp)
    2b16:	e8 7c 0f 00 00       	call   3a97 <open>
  if(fd >= 0){
    2b1b:	85 c0                	test   %eax,%eax
    2b1d:	0f 89 e4 00 00 00    	jns    2c07 <dirfile+0x153>
  fd = open("dirfile/xx", O_CREATE);
    2b23:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2b2a:	00 
    2b2b:	c7 04 24 7a 4b 00 00 	movl   $0x4b7a,(%esp)
    2b32:	e8 60 0f 00 00       	call   3a97 <open>
  if(fd >= 0){
    2b37:	85 c0                	test   %eax,%eax
    2b39:	0f 89 c8 00 00 00    	jns    2c07 <dirfile+0x153>
  if(mkdir("dirfile/xx") == 0){
    2b3f:	c7 04 24 7a 4b 00 00 	movl   $0x4b7a,(%esp)
    2b46:	e8 74 0f 00 00       	call   3abf <mkdir>
    2b4b:	85 c0                	test   %eax,%eax
    2b4d:	0f 84 7c 01 00 00    	je     2ccf <dirfile+0x21b>
  if(unlink("dirfile/xx") == 0){
    2b53:	c7 04 24 7a 4b 00 00 	movl   $0x4b7a,(%esp)
    2b5a:	e8 48 0f 00 00       	call   3aa7 <unlink>
    2b5f:	85 c0                	test   %eax,%eax
    2b61:	0f 84 4f 01 00 00    	je     2cb6 <dirfile+0x202>
  if(link("README", "dirfile/xx") == 0){
    2b67:	c7 44 24 04 7a 4b 00 	movl   $0x4b7a,0x4(%esp)
    2b6e:	00 
    2b6f:	c7 04 24 de 4b 00 00 	movl   $0x4bde,(%esp)
    2b76:	e8 3c 0f 00 00       	call   3ab7 <link>
    2b7b:	85 c0                	test   %eax,%eax
    2b7d:	0f 84 1a 01 00 00    	je     2c9d <dirfile+0x1e9>
  if(unlink("dirfile") != 0){
    2b83:	c7 04 24 41 4b 00 00 	movl   $0x4b41,(%esp)
    2b8a:	e8 18 0f 00 00       	call   3aa7 <unlink>
    2b8f:	85 c0                	test   %eax,%eax
    2b91:	0f 85 ed 00 00 00    	jne    2c84 <dirfile+0x1d0>
  fd = open(".", O_RDWR);
    2b97:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2b9e:	00 
    2b9f:	c7 04 24 3a 47 00 00 	movl   $0x473a,(%esp)
    2ba6:	e8 ec 0e 00 00       	call   3a97 <open>
  if(fd >= 0){
    2bab:	85 c0                	test   %eax,%eax
    2bad:	0f 89 b8 00 00 00    	jns    2c6b <dirfile+0x1b7>
  fd = open(".", 0);
    2bb3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2bba:	00 
    2bbb:	c7 04 24 3a 47 00 00 	movl   $0x473a,(%esp)
    2bc2:	e8 d0 0e 00 00       	call   3a97 <open>
    2bc7:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    2bc9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2bd0:	00 
    2bd1:	c7 44 24 04 1d 48 00 	movl   $0x481d,0x4(%esp)
    2bd8:	00 
    2bd9:	89 04 24             	mov    %eax,(%esp)
    2bdc:	e8 96 0e 00 00       	call   3a77 <write>
    2be1:	85 c0                	test   %eax,%eax
    2be3:	7f 6d                	jg     2c52 <dirfile+0x19e>
  close(fd);
    2be5:	89 1c 24             	mov    %ebx,(%esp)
    2be8:	e8 92 0e 00 00       	call   3a7f <close>
  printf(1, "dir vs file OK\n");
    2bed:	c7 44 24 04 11 4c 00 	movl   $0x4c11,0x4(%esp)
    2bf4:	00 
    2bf5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bfc:	e8 9f 0f 00 00       	call   3ba0 <printf>
}
    2c01:	83 c4 14             	add    $0x14,%esp
    2c04:	5b                   	pop    %ebx
    2c05:	5d                   	pop    %ebp
    2c06:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    2c07:	c7 44 24 04 85 4b 00 	movl   $0x4b85,0x4(%esp)
    2c0e:	00 
    2c0f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c16:	e8 85 0f 00 00       	call   3ba0 <printf>
    exit();
    2c1b:	e8 37 0e 00 00       	call   3a57 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2c20:	c7 44 24 04 60 4b 00 	movl   $0x4b60,0x4(%esp)
    2c27:	00 
    2c28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c2f:	e8 6c 0f 00 00       	call   3ba0 <printf>
    exit();
    2c34:	e8 1e 0e 00 00       	call   3a57 <exit>
    printf(1, "create dirfile failed\n");
    2c39:	c7 44 24 04 49 4b 00 	movl   $0x4b49,0x4(%esp)
    2c40:	00 
    2c41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c48:	e8 53 0f 00 00       	call   3ba0 <printf>
    exit();
    2c4d:	e8 05 0e 00 00       	call   3a57 <exit>
    printf(1, "write . succeeded!\n");
    2c52:	c7 44 24 04 fd 4b 00 	movl   $0x4bfd,0x4(%esp)
    2c59:	00 
    2c5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c61:	e8 3a 0f 00 00       	call   3ba0 <printf>
    exit();
    2c66:	e8 ec 0d 00 00       	call   3a57 <exit>
    printf(1, "open . for writing succeeded!\n");
    2c6b:	c7 44 24 04 f4 53 00 	movl   $0x53f4,0x4(%esp)
    2c72:	00 
    2c73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c7a:	e8 21 0f 00 00       	call   3ba0 <printf>
    exit();
    2c7f:	e8 d3 0d 00 00       	call   3a57 <exit>
    printf(1, "unlink dirfile failed!\n");
    2c84:	c7 44 24 04 e5 4b 00 	movl   $0x4be5,0x4(%esp)
    2c8b:	00 
    2c8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c93:	e8 08 0f 00 00       	call   3ba0 <printf>
    exit();
    2c98:	e8 ba 0d 00 00       	call   3a57 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    2c9d:	c7 44 24 04 d4 53 00 	movl   $0x53d4,0x4(%esp)
    2ca4:	00 
    2ca5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cac:	e8 ef 0e 00 00       	call   3ba0 <printf>
    exit();
    2cb1:	e8 a1 0d 00 00       	call   3a57 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2cb6:	c7 44 24 04 c0 4b 00 	movl   $0x4bc0,0x4(%esp)
    2cbd:	00 
    2cbe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cc5:	e8 d6 0e 00 00       	call   3ba0 <printf>
    exit();
    2cca:	e8 88 0d 00 00       	call   3a57 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2ccf:	c7 44 24 04 a3 4b 00 	movl   $0x4ba3,0x4(%esp)
    2cd6:	00 
    2cd7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cde:	e8 bd 0e 00 00       	call   3ba0 <printf>
    exit();
    2ce3:	e8 6f 0d 00 00       	call   3a57 <exit>

00002ce8 <iref>:
{
    2ce8:	55                   	push   %ebp
    2ce9:	89 e5                	mov    %esp,%ebp
    2ceb:	53                   	push   %ebx
    2cec:	83 ec 14             	sub    $0x14,%esp
  printf(1, "empty file name\n");
    2cef:	c7 44 24 04 21 4c 00 	movl   $0x4c21,0x4(%esp)
    2cf6:	00 
    2cf7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cfe:	e8 9d 0e 00 00       	call   3ba0 <printf>
    2d03:	bb 33 00 00 00       	mov    $0x33,%ebx
    if(mkdir("irefd") != 0){
    2d08:	c7 04 24 32 4c 00 00 	movl   $0x4c32,(%esp)
    2d0f:	e8 ab 0d 00 00       	call   3abf <mkdir>
    2d14:	85 c0                	test   %eax,%eax
    2d16:	0f 85 ad 00 00 00    	jne    2dc9 <iref+0xe1>
    if(chdir("irefd") != 0){
    2d1c:	c7 04 24 32 4c 00 00 	movl   $0x4c32,(%esp)
    2d23:	e8 9f 0d 00 00       	call   3ac7 <chdir>
    2d28:	85 c0                	test   %eax,%eax
    2d2a:	0f 85 b2 00 00 00    	jne    2de2 <iref+0xfa>
    mkdir("");
    2d30:	c7 04 24 e7 42 00 00 	movl   $0x42e7,(%esp)
    2d37:	e8 83 0d 00 00       	call   3abf <mkdir>
    link("README", "");
    2d3c:	c7 44 24 04 e7 42 00 	movl   $0x42e7,0x4(%esp)
    2d43:	00 
    2d44:	c7 04 24 de 4b 00 00 	movl   $0x4bde,(%esp)
    2d4b:	e8 67 0d 00 00       	call   3ab7 <link>
    fd = open("", O_CREATE);
    2d50:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d57:	00 
    2d58:	c7 04 24 e7 42 00 00 	movl   $0x42e7,(%esp)
    2d5f:	e8 33 0d 00 00       	call   3a97 <open>
    if(fd >= 0)
    2d64:	85 c0                	test   %eax,%eax
    2d66:	78 08                	js     2d70 <iref+0x88>
      close(fd);
    2d68:	89 04 24             	mov    %eax,(%esp)
    2d6b:	e8 0f 0d 00 00       	call   3a7f <close>
    fd = open("xx", O_CREATE);
    2d70:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d77:	00 
    2d78:	c7 04 24 1c 48 00 00 	movl   $0x481c,(%esp)
    2d7f:	e8 13 0d 00 00       	call   3a97 <open>
    if(fd >= 0)
    2d84:	85 c0                	test   %eax,%eax
    2d86:	78 08                	js     2d90 <iref+0xa8>
      close(fd);
    2d88:	89 04 24             	mov    %eax,(%esp)
    2d8b:	e8 ef 0c 00 00       	call   3a7f <close>
    unlink("xx");
    2d90:	c7 04 24 1c 48 00 00 	movl   $0x481c,(%esp)
    2d97:	e8 0b 0d 00 00       	call   3aa7 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2d9c:	4b                   	dec    %ebx
    2d9d:	0f 85 65 ff ff ff    	jne    2d08 <iref+0x20>
  chdir("/");
    2da3:	c7 04 24 0d 3f 00 00 	movl   $0x3f0d,(%esp)
    2daa:	e8 18 0d 00 00       	call   3ac7 <chdir>
  printf(1, "empty file name OK\n");
    2daf:	c7 44 24 04 60 4c 00 	movl   $0x4c60,0x4(%esp)
    2db6:	00 
    2db7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dbe:	e8 dd 0d 00 00       	call   3ba0 <printf>
}
    2dc3:	83 c4 14             	add    $0x14,%esp
    2dc6:	5b                   	pop    %ebx
    2dc7:	5d                   	pop    %ebp
    2dc8:	c3                   	ret    
      printf(1, "mkdir irefd failed\n");
    2dc9:	c7 44 24 04 38 4c 00 	movl   $0x4c38,0x4(%esp)
    2dd0:	00 
    2dd1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dd8:	e8 c3 0d 00 00       	call   3ba0 <printf>
      exit();
    2ddd:	e8 75 0c 00 00       	call   3a57 <exit>
      printf(1, "chdir irefd failed\n");
    2de2:	c7 44 24 04 4c 4c 00 	movl   $0x4c4c,0x4(%esp)
    2de9:	00 
    2dea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2df1:	e8 aa 0d 00 00       	call   3ba0 <printf>
      exit();
    2df6:	e8 5c 0c 00 00       	call   3a57 <exit>
    2dfb:	90                   	nop

00002dfc <forktest>:
{
    2dfc:	55                   	push   %ebp
    2dfd:	89 e5                	mov    %esp,%ebp
    2dff:	53                   	push   %ebx
    2e00:	83 ec 14             	sub    $0x14,%esp
  printf(1, "fork test\n");
    2e03:	c7 44 24 04 74 4c 00 	movl   $0x4c74,0x4(%esp)
    2e0a:	00 
    2e0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e12:	e8 89 0d 00 00       	call   3ba0 <printf>
  for(n=0; n<1000; n++){
    2e17:	31 db                	xor    %ebx,%ebx
    2e19:	eb 0c                	jmp    2e27 <forktest+0x2b>
    2e1b:	90                   	nop
    if(pid == 0)
    2e1c:	74 77                	je     2e95 <forktest+0x99>
  for(n=0; n<1000; n++){
    2e1e:	43                   	inc    %ebx
    2e1f:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2e25:	74 41                	je     2e68 <forktest+0x6c>
    pid = fork();
    2e27:	e8 23 0c 00 00       	call   3a4f <fork>
    if(pid < 0)
    2e2c:	83 f8 00             	cmp    $0x0,%eax
    2e2f:	7d eb                	jge    2e1c <forktest+0x20>
  for(; n > 0; n--){
    2e31:	85 db                	test   %ebx,%ebx
    2e33:	74 0f                	je     2e44 <forktest+0x48>
    2e35:	8d 76 00             	lea    0x0(%esi),%esi
    if(wait() < 0){
    2e38:	e8 22 0c 00 00       	call   3a5f <wait>
    2e3d:	85 c0                	test   %eax,%eax
    2e3f:	78 40                	js     2e81 <forktest+0x85>
  for(; n > 0; n--){
    2e41:	4b                   	dec    %ebx
    2e42:	75 f4                	jne    2e38 <forktest+0x3c>
  if(wait() != -1){
    2e44:	e8 16 0c 00 00       	call   3a5f <wait>
    2e49:	40                   	inc    %eax
    2e4a:	75 4e                	jne    2e9a <forktest+0x9e>
  printf(1, "fork test OK\n");
    2e4c:	c7 44 24 04 a6 4c 00 	movl   $0x4ca6,0x4(%esp)
    2e53:	00 
    2e54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e5b:	e8 40 0d 00 00       	call   3ba0 <printf>
}
    2e60:	83 c4 14             	add    $0x14,%esp
    2e63:	5b                   	pop    %ebx
    2e64:	5d                   	pop    %ebp
    2e65:	c3                   	ret    
    2e66:	66 90                	xchg   %ax,%ax
    printf(1, "fork claimed to work 1000 times!\n");
    2e68:	c7 44 24 04 14 54 00 	movl   $0x5414,0x4(%esp)
    2e6f:	00 
    2e70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e77:	e8 24 0d 00 00       	call   3ba0 <printf>
    exit();
    2e7c:	e8 d6 0b 00 00       	call   3a57 <exit>
      printf(1, "wait stopped early\n");
    2e81:	c7 44 24 04 7f 4c 00 	movl   $0x4c7f,0x4(%esp)
    2e88:	00 
    2e89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e90:	e8 0b 0d 00 00       	call   3ba0 <printf>
      exit();
    2e95:	e8 bd 0b 00 00       	call   3a57 <exit>
    printf(1, "wait got too many\n");
    2e9a:	c7 44 24 04 93 4c 00 	movl   $0x4c93,0x4(%esp)
    2ea1:	00 
    2ea2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ea9:	e8 f2 0c 00 00       	call   3ba0 <printf>
    exit();
    2eae:	e8 a4 0b 00 00       	call   3a57 <exit>
    2eb3:	90                   	nop

00002eb4 <sbrktest>:
{
    2eb4:	55                   	push   %ebp
    2eb5:	89 e5                	mov    %esp,%ebp
    2eb7:	57                   	push   %edi
    2eb8:	56                   	push   %esi
    2eb9:	53                   	push   %ebx
    2eba:	83 ec 7c             	sub    $0x7c,%esp
  printf(stdout, "sbrk test\n");
    2ebd:	c7 44 24 04 b4 4c 00 	movl   $0x4cb4,0x4(%esp)
    2ec4:	00 
    2ec5:	a1 60 5f 00 00       	mov    0x5f60,%eax
    2eca:	89 04 24             	mov    %eax,(%esp)
    2ecd:	e8 ce 0c 00 00       	call   3ba0 <printf>
  oldbrk = sbrk(0);
    2ed2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ed9:	e8 09 0c 00 00       	call   3ae7 <sbrk>
    2ede:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  a = sbrk(0);
    2ee1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ee8:	e8 fa 0b 00 00       	call   3ae7 <sbrk>
    2eed:	89 c3                	mov    %eax,%ebx
  for(i = 0; i < 5000; i++){
    2eef:	31 f6                	xor    %esi,%esi
    2ef1:	8d 76 00             	lea    0x0(%esi),%esi
    b = sbrk(1);
    2ef4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2efb:	e8 e7 0b 00 00       	call   3ae7 <sbrk>
    if(b != a){
    2f00:	39 d8                	cmp    %ebx,%eax
    2f02:	0f 85 6e 02 00 00    	jne    3176 <sbrktest+0x2c2>
    *b = 1;
    2f08:	c6 03 01             	movb   $0x1,(%ebx)
    a = b + 1;
    2f0b:	43                   	inc    %ebx
  for(i = 0; i < 5000; i++){
    2f0c:	46                   	inc    %esi
    2f0d:	81 fe 88 13 00 00    	cmp    $0x1388,%esi
    2f13:	75 df                	jne    2ef4 <sbrktest+0x40>
  pid = fork();
    2f15:	e8 35 0b 00 00       	call   3a4f <fork>
    2f1a:	89 c6                	mov    %eax,%esi
  if(pid < 0){
    2f1c:	85 c0                	test   %eax,%eax
    2f1e:	0f 88 c0 03 00 00    	js     32e4 <sbrktest+0x430>
  c = sbrk(1);
    2f24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f2b:	e8 b7 0b 00 00       	call   3ae7 <sbrk>
  c = sbrk(1);
    2f30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f37:	e8 ab 0b 00 00       	call   3ae7 <sbrk>
  if(c != a + 1){
    2f3c:	43                   	inc    %ebx
    2f3d:	39 d8                	cmp    %ebx,%eax
    2f3f:	0f 85 85 03 00 00    	jne    32ca <sbrktest+0x416>
  if(pid == 0)
    2f45:	85 f6                	test   %esi,%esi
    2f47:	0f 84 78 03 00 00    	je     32c5 <sbrktest+0x411>
  wait();
    2f4d:	e8 0d 0b 00 00       	call   3a5f <wait>
  a = sbrk(0);
    2f52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f59:	e8 89 0b 00 00       	call   3ae7 <sbrk>
    2f5e:	89 c3                	mov    %eax,%ebx
  amt = (BIG) - (uint)a;
    2f60:	ba 00 00 40 06       	mov    $0x6400000,%edx
    2f65:	29 c2                	sub    %eax,%edx
  p = sbrk(amt);
    2f67:	89 14 24             	mov    %edx,(%esp)
    2f6a:	e8 78 0b 00 00       	call   3ae7 <sbrk>
  if (p != a) {
    2f6f:	39 d8                	cmp    %ebx,%eax
    2f71:	0f 85 39 03 00 00    	jne    32b0 <sbrktest+0x3fc>
  *lastaddr = 99;
    2f77:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff
  a = sbrk(0);
    2f7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f85:	e8 5d 0b 00 00       	call   3ae7 <sbrk>
    2f8a:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
    2f8c:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    2f93:	e8 4f 0b 00 00       	call   3ae7 <sbrk>
  if(c == (char*)0xffffffff){
    2f98:	40                   	inc    %eax
    2f99:	0f 84 f7 02 00 00    	je     3296 <sbrktest+0x3e2>
  c = sbrk(0);
    2f9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fa6:	e8 3c 0b 00 00       	call   3ae7 <sbrk>
  if(c != a - 4096){
    2fab:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
    2fb1:	39 d0                	cmp    %edx,%eax
    2fb3:	0f 85 bb 02 00 00    	jne    3274 <sbrktest+0x3c0>
  a = sbrk(0);
    2fb9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fc0:	e8 22 0b 00 00       	call   3ae7 <sbrk>
    2fc5:	89 c6                	mov    %eax,%esi
  c = sbrk(4096);
    2fc7:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    2fce:	e8 14 0b 00 00       	call   3ae7 <sbrk>
    2fd3:	89 c3                	mov    %eax,%ebx
  if(c != a || sbrk(0) != a + 4096){
    2fd5:	39 f0                	cmp    %esi,%eax
    2fd7:	0f 85 75 02 00 00    	jne    3252 <sbrktest+0x39e>
    2fdd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fe4:	e8 fe 0a 00 00       	call   3ae7 <sbrk>
    2fe9:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
    2fef:	39 d0                	cmp    %edx,%eax
    2ff1:	0f 85 5b 02 00 00    	jne    3252 <sbrktest+0x39e>
  if(*lastaddr == 99){
    2ff7:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2ffe:	0f 84 34 02 00 00    	je     3238 <sbrktest+0x384>
  a = sbrk(0);
    3004:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    300b:	e8 d7 0a 00 00       	call   3ae7 <sbrk>
    3010:	89 c3                	mov    %eax,%ebx
  c = sbrk(-(sbrk(0) - oldbrk));
    3012:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3019:	e8 c9 0a 00 00       	call   3ae7 <sbrk>
    301e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
    3021:	29 c2                	sub    %eax,%edx
    3023:	89 14 24             	mov    %edx,(%esp)
    3026:	e8 bc 0a 00 00       	call   3ae7 <sbrk>
  if(c != a){
    302b:	39 d8                	cmp    %ebx,%eax
    302d:	0f 85 e3 01 00 00    	jne    3216 <sbrktest+0x362>
    3033:	bb 00 00 00 80       	mov    $0x80000000,%ebx
    ppid = getpid();
    3038:	e8 9a 0a 00 00       	call   3ad7 <getpid>
    303d:	89 c6                	mov    %eax,%esi
    pid = fork();
    303f:	e8 0b 0a 00 00       	call   3a4f <fork>
    if(pid < 0){
    3044:	83 f8 00             	cmp    $0x0,%eax
    3047:	0f 8c af 01 00 00    	jl     31fc <sbrktest+0x348>
    if(pid == 0){
    304d:	0f 84 7c 01 00 00    	je     31cf <sbrktest+0x31b>
    wait();
    3053:	e8 07 0a 00 00       	call   3a5f <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3058:	81 c3 50 c3 00 00    	add    $0xc350,%ebx
    305e:	81 fb 80 84 1e 80    	cmp    $0x801e8480,%ebx
    3064:	75 d2                	jne    3038 <sbrktest+0x184>
  if(pipe(fds) != 0){
    3066:	8d 45 b8             	lea    -0x48(%ebp),%eax
    3069:	89 04 24             	mov    %eax,(%esp)
    306c:	e8 f6 09 00 00       	call   3a67 <pipe>
    3071:	85 c0                	test   %eax,%eax
    3073:	0f 85 3d 01 00 00    	jne    31b6 <sbrktest+0x302>
    3079:	8d 5d c0             	lea    -0x40(%ebp),%ebx
sbrktest(void)
    307c:	8d 75 e8             	lea    -0x18(%ebp),%esi
    307f:	89 df                	mov    %ebx,%edi
    if((pids[i] = fork()) == 0){
    3081:	e8 c9 09 00 00       	call   3a4f <fork>
    3086:	89 07                	mov    %eax,(%edi)
    3088:	85 c0                	test   %eax,%eax
    308a:	0f 84 9f 00 00 00    	je     312f <sbrktest+0x27b>
    if(pids[i] != -1)
    3090:	40                   	inc    %eax
    3091:	74 1a                	je     30ad <sbrktest+0x1f9>
      read(fds[0], &scratch, 1);
    3093:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    309a:	00 
    309b:	8d 45 b7             	lea    -0x49(%ebp),%eax
    309e:	89 44 24 04          	mov    %eax,0x4(%esp)
    30a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
    30a5:	89 04 24             	mov    %eax,(%esp)
    30a8:	e8 c2 09 00 00       	call   3a6f <read>
    30ad:	83 c7 04             	add    $0x4,%edi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    30b0:	39 f7                	cmp    %esi,%edi
    30b2:	75 cd                	jne    3081 <sbrktest+0x1cd>
  c = sbrk(4096);
    30b4:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    30bb:	e8 27 0a 00 00       	call   3ae7 <sbrk>
    30c0:	89 45 a0             	mov    %eax,-0x60(%ebp)
    if(pids[i] == -1)
    30c3:	8b 03                	mov    (%ebx),%eax
    30c5:	83 f8 ff             	cmp    $0xffffffff,%eax
    30c8:	74 0d                	je     30d7 <sbrktest+0x223>
    kill(pids[i]);
    30ca:	89 04 24             	mov    %eax,(%esp)
    30cd:	e8 b5 09 00 00       	call   3a87 <kill>
    wait();
    30d2:	e8 88 09 00 00       	call   3a5f <wait>
    30d7:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    30da:	39 de                	cmp    %ebx,%esi
    30dc:	75 e5                	jne    30c3 <sbrktest+0x20f>
  if(c == (char*)0xffffffff){
    30de:	83 7d a0 ff          	cmpl   $0xffffffff,-0x60(%ebp)
    30e2:	0f 84 b4 00 00 00    	je     319c <sbrktest+0x2e8>
  if(sbrk(0) > oldbrk)
    30e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    30ef:	e8 f3 09 00 00       	call   3ae7 <sbrk>
    30f4:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
    30f7:	73 19                	jae    3112 <sbrktest+0x25e>
    sbrk(-(sbrk(0) - oldbrk));
    30f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3100:	e8 e2 09 00 00       	call   3ae7 <sbrk>
    3105:	8b 7d a4             	mov    -0x5c(%ebp),%edi
    3108:	29 c7                	sub    %eax,%edi
    310a:	89 3c 24             	mov    %edi,(%esp)
    310d:	e8 d5 09 00 00       	call   3ae7 <sbrk>
  printf(stdout, "sbrk test OK\n");
    3112:	c7 44 24 04 5c 4d 00 	movl   $0x4d5c,0x4(%esp)
    3119:	00 
    311a:	a1 60 5f 00 00       	mov    0x5f60,%eax
    311f:	89 04 24             	mov    %eax,(%esp)
    3122:	e8 79 0a 00 00       	call   3ba0 <printf>
}
    3127:	83 c4 7c             	add    $0x7c,%esp
    312a:	5b                   	pop    %ebx
    312b:	5e                   	pop    %esi
    312c:	5f                   	pop    %edi
    312d:	5d                   	pop    %ebp
    312e:	c3                   	ret    
      sbrk(BIG - (uint)sbrk(0));
    312f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3136:	e8 ac 09 00 00       	call   3ae7 <sbrk>
    313b:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3140:	29 c2                	sub    %eax,%edx
    3142:	89 14 24             	mov    %edx,(%esp)
    3145:	e8 9d 09 00 00       	call   3ae7 <sbrk>
      write(fds[1], "x", 1);
    314a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3151:	00 
    3152:	c7 44 24 04 1d 48 00 	movl   $0x481d,0x4(%esp)
    3159:	00 
    315a:	8b 45 bc             	mov    -0x44(%ebp),%eax
    315d:	89 04 24             	mov    %eax,(%esp)
    3160:	e8 12 09 00 00       	call   3a77 <write>
    3165:	8d 76 00             	lea    0x0(%esi),%esi
      for(;;) sleep(1000);
    3168:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    316f:	e8 7b 09 00 00       	call   3aef <sleep>
    3174:	eb f2                	jmp    3168 <sbrktest+0x2b4>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    3176:	89 44 24 10          	mov    %eax,0x10(%esp)
    317a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    317e:	89 74 24 08          	mov    %esi,0x8(%esp)
    3182:	c7 44 24 04 bf 4c 00 	movl   $0x4cbf,0x4(%esp)
    3189:	00 
    318a:	a1 60 5f 00 00       	mov    0x5f60,%eax
    318f:	89 04 24             	mov    %eax,(%esp)
    3192:	e8 09 0a 00 00       	call   3ba0 <printf>
      exit();
    3197:	e8 bb 08 00 00       	call   3a57 <exit>
    printf(stdout, "failed sbrk leaked memory\n");
    319c:	c7 44 24 04 41 4d 00 	movl   $0x4d41,0x4(%esp)
    31a3:	00 
    31a4:	a1 60 5f 00 00       	mov    0x5f60,%eax
    31a9:	89 04 24             	mov    %eax,(%esp)
    31ac:	e8 ef 09 00 00       	call   3ba0 <printf>
    exit();
    31b1:	e8 a1 08 00 00       	call   3a57 <exit>
    printf(1, "pipe() failed\n");
    31b6:	c7 44 24 04 fd 41 00 	movl   $0x41fd,0x4(%esp)
    31bd:	00 
    31be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31c5:	e8 d6 09 00 00       	call   3ba0 <printf>
    exit();
    31ca:	e8 88 08 00 00       	call   3a57 <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    31cf:	0f be 03             	movsbl (%ebx),%eax
    31d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
    31d6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    31da:	c7 44 24 04 28 4d 00 	movl   $0x4d28,0x4(%esp)
    31e1:	00 
    31e2:	a1 60 5f 00 00       	mov    0x5f60,%eax
    31e7:	89 04 24             	mov    %eax,(%esp)
    31ea:	e8 b1 09 00 00       	call   3ba0 <printf>
      kill(ppid);
    31ef:	89 34 24             	mov    %esi,(%esp)
    31f2:	e8 90 08 00 00       	call   3a87 <kill>
      exit();
    31f7:	e8 5b 08 00 00       	call   3a57 <exit>
      printf(stdout, "fork failed\n");
    31fc:	c7 44 24 04 05 4e 00 	movl   $0x4e05,0x4(%esp)
    3203:	00 
    3204:	a1 60 5f 00 00       	mov    0x5f60,%eax
    3209:	89 04 24             	mov    %eax,(%esp)
    320c:	e8 8f 09 00 00       	call   3ba0 <printf>
      exit();
    3211:	e8 41 08 00 00       	call   3a57 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    3216:	89 44 24 0c          	mov    %eax,0xc(%esp)
    321a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    321e:	c7 44 24 04 08 55 00 	movl   $0x5508,0x4(%esp)
    3225:	00 
    3226:	a1 60 5f 00 00       	mov    0x5f60,%eax
    322b:	89 04 24             	mov    %eax,(%esp)
    322e:	e8 6d 09 00 00       	call   3ba0 <printf>
    exit();
    3233:	e8 1f 08 00 00       	call   3a57 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3238:	c7 44 24 04 d8 54 00 	movl   $0x54d8,0x4(%esp)
    323f:	00 
    3240:	a1 60 5f 00 00       	mov    0x5f60,%eax
    3245:	89 04 24             	mov    %eax,(%esp)
    3248:	e8 53 09 00 00       	call   3ba0 <printf>
    exit();
    324d:	e8 05 08 00 00       	call   3a57 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3252:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    3256:	89 74 24 08          	mov    %esi,0x8(%esp)
    325a:	c7 44 24 04 b0 54 00 	movl   $0x54b0,0x4(%esp)
    3261:	00 
    3262:	a1 60 5f 00 00       	mov    0x5f60,%eax
    3267:	89 04 24             	mov    %eax,(%esp)
    326a:	e8 31 09 00 00       	call   3ba0 <printf>
    exit();
    326f:	e8 e3 07 00 00       	call   3a57 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3274:	89 44 24 0c          	mov    %eax,0xc(%esp)
    3278:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    327c:	c7 44 24 04 78 54 00 	movl   $0x5478,0x4(%esp)
    3283:	00 
    3284:	a1 60 5f 00 00       	mov    0x5f60,%eax
    3289:	89 04 24             	mov    %eax,(%esp)
    328c:	e8 0f 09 00 00       	call   3ba0 <printf>
    exit();
    3291:	e8 c1 07 00 00       	call   3a57 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    3296:	c7 44 24 04 0d 4d 00 	movl   $0x4d0d,0x4(%esp)
    329d:	00 
    329e:	a1 60 5f 00 00       	mov    0x5f60,%eax
    32a3:	89 04 24             	mov    %eax,(%esp)
    32a6:	e8 f5 08 00 00       	call   3ba0 <printf>
    exit();
    32ab:	e8 a7 07 00 00       	call   3a57 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    32b0:	c7 44 24 04 38 54 00 	movl   $0x5438,0x4(%esp)
    32b7:	00 
    32b8:	a1 60 5f 00 00       	mov    0x5f60,%eax
    32bd:	89 04 24             	mov    %eax,(%esp)
    32c0:	e8 db 08 00 00       	call   3ba0 <printf>
    exit();
    32c5:	e8 8d 07 00 00       	call   3a57 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    32ca:	c7 44 24 04 f1 4c 00 	movl   $0x4cf1,0x4(%esp)
    32d1:	00 
    32d2:	a1 60 5f 00 00       	mov    0x5f60,%eax
    32d7:	89 04 24             	mov    %eax,(%esp)
    32da:	e8 c1 08 00 00       	call   3ba0 <printf>
    exit();
    32df:	e8 73 07 00 00       	call   3a57 <exit>
    printf(stdout, "sbrk test fork failed\n");
    32e4:	c7 44 24 04 da 4c 00 	movl   $0x4cda,0x4(%esp)
    32eb:	00 
    32ec:	a1 60 5f 00 00       	mov    0x5f60,%eax
    32f1:	89 04 24             	mov    %eax,(%esp)
    32f4:	e8 a7 08 00 00       	call   3ba0 <printf>
    exit();
    32f9:	e8 59 07 00 00       	call   3a57 <exit>
    32fe:	66 90                	xchg   %ax,%ax

00003300 <validateint>:
{
    3300:	55                   	push   %ebp
    3301:	89 e5                	mov    %esp,%ebp
}
    3303:	5d                   	pop    %ebp
    3304:	c3                   	ret    
    3305:	8d 76 00             	lea    0x0(%esi),%esi

00003308 <validatetest>:
{
    3308:	55                   	push   %ebp
    3309:	89 e5                	mov    %esp,%ebp
    330b:	56                   	push   %esi
    330c:	53                   	push   %ebx
    330d:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "validate test\n");
    3310:	c7 44 24 04 6a 4d 00 	movl   $0x4d6a,0x4(%esp)
    3317:	00 
    3318:	a1 60 5f 00 00       	mov    0x5f60,%eax
    331d:	89 04 24             	mov    %eax,(%esp)
    3320:	e8 7b 08 00 00       	call   3ba0 <printf>
  for(p = 0; p <= (uint)hi; p += 4096){
    3325:	31 db                	xor    %ebx,%ebx
    3327:	90                   	nop
    if((pid = fork()) == 0){
    3328:	e8 22 07 00 00       	call   3a4f <fork>
    332d:	89 c6                	mov    %eax,%esi
    332f:	85 c0                	test   %eax,%eax
    3331:	74 77                	je     33aa <validatetest+0xa2>
    sleep(0);
    3333:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    333a:	e8 b0 07 00 00       	call   3aef <sleep>
    sleep(0);
    333f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3346:	e8 a4 07 00 00       	call   3aef <sleep>
    kill(pid);
    334b:	89 34 24             	mov    %esi,(%esp)
    334e:	e8 34 07 00 00       	call   3a87 <kill>
    wait();
    3353:	e8 07 07 00 00       	call   3a5f <wait>
    if(link("nosuchfile", (char*)p) != -1){
    3358:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    335c:	c7 04 24 79 4d 00 00 	movl   $0x4d79,(%esp)
    3363:	e8 4f 07 00 00       	call   3ab7 <link>
    3368:	40                   	inc    %eax
    3369:	75 2a                	jne    3395 <validatetest+0x8d>
  for(p = 0; p <= (uint)hi; p += 4096){
    336b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    3371:	81 fb 00 40 11 00    	cmp    $0x114000,%ebx
    3377:	75 af                	jne    3328 <validatetest+0x20>
  printf(stdout, "validate ok\n");
    3379:	c7 44 24 04 9d 4d 00 	movl   $0x4d9d,0x4(%esp)
    3380:	00 
    3381:	a1 60 5f 00 00       	mov    0x5f60,%eax
    3386:	89 04 24             	mov    %eax,(%esp)
    3389:	e8 12 08 00 00       	call   3ba0 <printf>
}
    338e:	83 c4 10             	add    $0x10,%esp
    3391:	5b                   	pop    %ebx
    3392:	5e                   	pop    %esi
    3393:	5d                   	pop    %ebp
    3394:	c3                   	ret    
      printf(stdout, "link should not succeed\n");
    3395:	c7 44 24 04 84 4d 00 	movl   $0x4d84,0x4(%esp)
    339c:	00 
    339d:	a1 60 5f 00 00       	mov    0x5f60,%eax
    33a2:	89 04 24             	mov    %eax,(%esp)
    33a5:	e8 f6 07 00 00       	call   3ba0 <printf>
      exit();
    33aa:	e8 a8 06 00 00       	call   3a57 <exit>
    33af:	90                   	nop

000033b0 <bsstest>:
{
    33b0:	55                   	push   %ebp
    33b1:	89 e5                	mov    %esp,%ebp
    33b3:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "bss test\n");
    33b6:	c7 44 24 04 aa 4d 00 	movl   $0x4daa,0x4(%esp)
    33bd:	00 
    33be:	a1 60 5f 00 00       	mov    0x5f60,%eax
    33c3:	89 04 24             	mov    %eax,(%esp)
    33c6:	e8 d5 07 00 00       	call   3ba0 <printf>
    if(uninit[i] != '\0'){
    33cb:	80 3d 20 60 00 00 00 	cmpb   $0x0,0x6020
    33d2:	75 30                	jne    3404 <bsstest+0x54>
    33d4:	b8 01 00 00 00       	mov    $0x1,%eax
    33d9:	8d 76 00             	lea    0x0(%esi),%esi
    33dc:	80 b8 20 60 00 00 00 	cmpb   $0x0,0x6020(%eax)
    33e3:	75 1f                	jne    3404 <bsstest+0x54>
  for(i = 0; i < sizeof(uninit); i++){
    33e5:	40                   	inc    %eax
    33e6:	3d 10 27 00 00       	cmp    $0x2710,%eax
    33eb:	75 ef                	jne    33dc <bsstest+0x2c>
  printf(stdout, "bss test ok\n");
    33ed:	c7 44 24 04 c5 4d 00 	movl   $0x4dc5,0x4(%esp)
    33f4:	00 
    33f5:	a1 60 5f 00 00       	mov    0x5f60,%eax
    33fa:	89 04 24             	mov    %eax,(%esp)
    33fd:	e8 9e 07 00 00       	call   3ba0 <printf>
}
    3402:	c9                   	leave  
    3403:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    3404:	c7 44 24 04 b4 4d 00 	movl   $0x4db4,0x4(%esp)
    340b:	00 
    340c:	a1 60 5f 00 00       	mov    0x5f60,%eax
    3411:	89 04 24             	mov    %eax,(%esp)
    3414:	e8 87 07 00 00       	call   3ba0 <printf>
      exit();
    3419:	e8 39 06 00 00       	call   3a57 <exit>
    341e:	66 90                	xchg   %ax,%ax

00003420 <bigargtest>:
{
    3420:	55                   	push   %ebp
    3421:	89 e5                	mov    %esp,%ebp
    3423:	83 ec 18             	sub    $0x18,%esp
  unlink("bigarg-ok");
    3426:	c7 04 24 d2 4d 00 00 	movl   $0x4dd2,(%esp)
    342d:	e8 75 06 00 00       	call   3aa7 <unlink>
  pid = fork();
    3432:	e8 18 06 00 00       	call   3a4f <fork>
  if(pid == 0){
    3437:	83 f8 00             	cmp    $0x0,%eax
    343a:	74 40                	je     347c <bigargtest+0x5c>
  } else if(pid < 0){
    343c:	0f 8c ce 00 00 00    	jl     3510 <bigargtest+0xf0>
  wait();
    3442:	e8 18 06 00 00       	call   3a5f <wait>
  fd = open("bigarg-ok", 0);
    3447:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    344e:	00 
    344f:	c7 04 24 d2 4d 00 00 	movl   $0x4dd2,(%esp)
    3456:	e8 3c 06 00 00       	call   3a97 <open>
  if(fd < 0){
    345b:	85 c0                	test   %eax,%eax
    345d:	0f 88 93 00 00 00    	js     34f6 <bigargtest+0xd6>
  close(fd);
    3463:	89 04 24             	mov    %eax,(%esp)
    3466:	e8 14 06 00 00       	call   3a7f <close>
  unlink("bigarg-ok");
    346b:	c7 04 24 d2 4d 00 00 	movl   $0x4dd2,(%esp)
    3472:	e8 30 06 00 00       	call   3aa7 <unlink>
}
    3477:	c9                   	leave  
    3478:	c3                   	ret    
    3479:	8d 76 00             	lea    0x0(%esi),%esi
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    347c:	c7 04 85 80 5f 00 00 	movl   $0x552c,0x5f80(,%eax,4)
    3483:	2c 55 00 00 
    for(i = 0; i < MAXARG-1; i++)
    3487:	40                   	inc    %eax
    3488:	83 f8 1f             	cmp    $0x1f,%eax
    348b:	75 ef                	jne    347c <bigargtest+0x5c>
    args[MAXARG-1] = 0;
    348d:	c7 05 fc 5f 00 00 00 	movl   $0x0,0x5ffc
    3494:	00 00 00 
    printf(stdout, "bigarg test\n");
    3497:	c7 44 24 04 dc 4d 00 	movl   $0x4ddc,0x4(%esp)
    349e:	00 
    349f:	a1 60 5f 00 00       	mov    0x5f60,%eax
    34a4:	89 04 24             	mov    %eax,(%esp)
    34a7:	e8 f4 06 00 00       	call   3ba0 <printf>
    exec("echo", args);
    34ac:	c7 44 24 04 80 5f 00 	movl   $0x5f80,0x4(%esp)
    34b3:	00 
    34b4:	c7 04 24 a9 3f 00 00 	movl   $0x3fa9,(%esp)
    34bb:	e8 cf 05 00 00       	call   3a8f <exec>
    printf(stdout, "bigarg test ok\n");
    34c0:	c7 44 24 04 e9 4d 00 	movl   $0x4de9,0x4(%esp)
    34c7:	00 
    34c8:	a1 60 5f 00 00       	mov    0x5f60,%eax
    34cd:	89 04 24             	mov    %eax,(%esp)
    34d0:	e8 cb 06 00 00       	call   3ba0 <printf>
    fd = open("bigarg-ok", O_CREATE);
    34d5:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    34dc:	00 
    34dd:	c7 04 24 d2 4d 00 00 	movl   $0x4dd2,(%esp)
    34e4:	e8 ae 05 00 00       	call   3a97 <open>
    close(fd);
    34e9:	89 04 24             	mov    %eax,(%esp)
    34ec:	e8 8e 05 00 00       	call   3a7f <close>
    exit();
    34f1:	e8 61 05 00 00       	call   3a57 <exit>
    printf(stdout, "bigarg test failed!\n");
    34f6:	c7 44 24 04 12 4e 00 	movl   $0x4e12,0x4(%esp)
    34fd:	00 
    34fe:	a1 60 5f 00 00       	mov    0x5f60,%eax
    3503:	89 04 24             	mov    %eax,(%esp)
    3506:	e8 95 06 00 00       	call   3ba0 <printf>
    exit();
    350b:	e8 47 05 00 00       	call   3a57 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    3510:	c7 44 24 04 f9 4d 00 	movl   $0x4df9,0x4(%esp)
    3517:	00 
    3518:	a1 60 5f 00 00       	mov    0x5f60,%eax
    351d:	89 04 24             	mov    %eax,(%esp)
    3520:	e8 7b 06 00 00       	call   3ba0 <printf>
    exit();
    3525:	e8 2d 05 00 00       	call   3a57 <exit>
    352a:	66 90                	xchg   %ax,%ax

0000352c <fsfull>:
{
    352c:	55                   	push   %ebp
    352d:	89 e5                	mov    %esp,%ebp
    352f:	57                   	push   %edi
    3530:	56                   	push   %esi
    3531:	53                   	push   %ebx
    3532:	83 ec 6c             	sub    $0x6c,%esp
  printf(1, "fsfull test\n");
    3535:	c7 44 24 04 27 4e 00 	movl   $0x4e27,0x4(%esp)
    353c:	00 
    353d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3544:	e8 57 06 00 00       	call   3ba0 <printf>
  for(nfiles = 0; ; nfiles++){
    3549:	31 f6                	xor    %esi,%esi
    354b:	90                   	nop
    name[0] = 'f';
    354c:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3550:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3555:	f7 ee                	imul   %esi
    3557:	89 55 a4             	mov    %edx,-0x5c(%ebp)
    355a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    355d:	c1 f8 06             	sar    $0x6,%eax
    3560:	89 f1                	mov    %esi,%ecx
    3562:	c1 f9 1f             	sar    $0x1f,%ecx
    3565:	29 c8                	sub    %ecx,%eax
    3567:	8d 50 30             	lea    0x30(%eax),%edx
    356a:	88 55 a9             	mov    %dl,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    356d:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3570:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3573:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3576:	c1 e0 03             	shl    $0x3,%eax
    3579:	89 f3                	mov    %esi,%ebx
    357b:	29 c3                	sub    %eax,%ebx
    357d:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3582:	f7 eb                	imul   %ebx
    3584:	89 55 a4             	mov    %edx,-0x5c(%ebp)
    3587:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    358a:	c1 f8 05             	sar    $0x5,%eax
    358d:	c1 fb 1f             	sar    $0x1f,%ebx
    3590:	29 d8                	sub    %ebx,%eax
    3592:	83 c0 30             	add    $0x30,%eax
    3595:	88 45 aa             	mov    %al,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3598:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    359d:	f7 ee                	imul   %esi
    359f:	89 55 a4             	mov    %edx,-0x5c(%ebp)
    35a2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    35a5:	c1 f8 05             	sar    $0x5,%eax
    35a8:	29 c8                	sub    %ecx,%eax
    35aa:	8d 04 80             	lea    (%eax,%eax,4),%eax
    35ad:	8d 04 80             	lea    (%eax,%eax,4),%eax
    35b0:	c1 e0 02             	shl    $0x2,%eax
    35b3:	89 f7                	mov    %esi,%edi
    35b5:	29 c7                	sub    %eax,%edi
    35b7:	bb 67 66 66 66       	mov    $0x66666667,%ebx
    35bc:	89 f8                	mov    %edi,%eax
    35be:	f7 eb                	imul   %ebx
    35c0:	c1 fa 02             	sar    $0x2,%edx
    35c3:	c1 ff 1f             	sar    $0x1f,%edi
    35c6:	29 fa                	sub    %edi,%edx
    35c8:	83 c2 30             	add    $0x30,%edx
    35cb:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    35ce:	89 f0                	mov    %esi,%eax
    35d0:	f7 eb                	imul   %ebx
    35d2:	c1 fa 02             	sar    $0x2,%edx
    35d5:	29 ca                	sub    %ecx,%edx
    35d7:	8d 04 92             	lea    (%edx,%edx,4),%eax
    35da:	d1 e0                	shl    %eax
    35dc:	89 f2                	mov    %esi,%edx
    35de:	29 c2                	sub    %eax,%edx
    35e0:	89 d0                	mov    %edx,%eax
    35e2:	83 c0 30             	add    $0x30,%eax
    35e5:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    35e8:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    printf(1, "writing %s\n", name);
    35ec:	8d 45 a8             	lea    -0x58(%ebp),%eax
    35ef:	89 44 24 08          	mov    %eax,0x8(%esp)
    35f3:	c7 44 24 04 34 4e 00 	movl   $0x4e34,0x4(%esp)
    35fa:	00 
    35fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3602:	e8 99 05 00 00       	call   3ba0 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3607:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    360e:	00 
    360f:	8d 55 a8             	lea    -0x58(%ebp),%edx
    3612:	89 14 24             	mov    %edx,(%esp)
    3615:	e8 7d 04 00 00       	call   3a97 <open>
    361a:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    361c:	85 c0                	test   %eax,%eax
    361e:	78 4f                	js     366f <fsfull+0x143>
    3620:	31 db                	xor    %ebx,%ebx
    3622:	eb 02                	jmp    3626 <fsfull+0xfa>
      total += cc;
    3624:	01 c3                	add    %eax,%ebx
      int cc = write(fd, buf, 512);
    3626:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    362d:	00 
    362e:	c7 44 24 04 40 87 00 	movl   $0x8740,0x4(%esp)
    3635:	00 
    3636:	89 3c 24             	mov    %edi,(%esp)
    3639:	e8 39 04 00 00       	call   3a77 <write>
      if(cc < 512)
    363e:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    3643:	7f df                	jg     3624 <fsfull+0xf8>
    printf(1, "wrote %d bytes\n", total);
    3645:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    3649:	c7 44 24 04 50 4e 00 	movl   $0x4e50,0x4(%esp)
    3650:	00 
    3651:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3658:	e8 43 05 00 00       	call   3ba0 <printf>
    close(fd);
    365d:	89 3c 24             	mov    %edi,(%esp)
    3660:	e8 1a 04 00 00       	call   3a7f <close>
    if(total == 0)
    3665:	85 db                	test   %ebx,%ebx
    3667:	74 23                	je     368c <fsfull+0x160>
  for(nfiles = 0; ; nfiles++){
    3669:	46                   	inc    %esi
  }
    366a:	e9 dd fe ff ff       	jmp    354c <fsfull+0x20>
      printf(1, "open %s failed\n", name);
    366f:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3672:	89 44 24 08          	mov    %eax,0x8(%esp)
    3676:	c7 44 24 04 40 4e 00 	movl   $0x4e40,0x4(%esp)
    367d:	00 
    367e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3685:	e8 16 05 00 00       	call   3ba0 <printf>
    368a:	66 90                	xchg   %ax,%ax
    name[0] = 'f';
    368c:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3690:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3695:	f7 ee                	imul   %esi
    3697:	89 55 a4             	mov    %edx,-0x5c(%ebp)
    369a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    369d:	c1 f8 06             	sar    $0x6,%eax
    36a0:	89 f1                	mov    %esi,%ecx
    36a2:	c1 f9 1f             	sar    $0x1f,%ecx
    36a5:	29 c8                	sub    %ecx,%eax
    36a7:	8d 50 30             	lea    0x30(%eax),%edx
    36aa:	88 55 a9             	mov    %dl,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    36ad:	8d 04 80             	lea    (%eax,%eax,4),%eax
    36b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
    36b3:	8d 04 80             	lea    (%eax,%eax,4),%eax
    36b6:	c1 e0 03             	shl    $0x3,%eax
    36b9:	89 f3                	mov    %esi,%ebx
    36bb:	29 c3                	sub    %eax,%ebx
    36bd:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    36c2:	f7 eb                	imul   %ebx
    36c4:	89 55 a4             	mov    %edx,-0x5c(%ebp)
    36c7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    36ca:	c1 f8 05             	sar    $0x5,%eax
    36cd:	c1 fb 1f             	sar    $0x1f,%ebx
    36d0:	29 d8                	sub    %ebx,%eax
    36d2:	83 c0 30             	add    $0x30,%eax
    36d5:	88 45 aa             	mov    %al,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    36d8:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    36dd:	f7 ee                	imul   %esi
    36df:	89 45 a0             	mov    %eax,-0x60(%ebp)
    36e2:	89 55 a4             	mov    %edx,-0x5c(%ebp)
    36e5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    36e8:	c1 f8 05             	sar    $0x5,%eax
    36eb:	29 c8                	sub    %ecx,%eax
    36ed:	8d 04 80             	lea    (%eax,%eax,4),%eax
    36f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
    36f3:	c1 e0 02             	shl    $0x2,%eax
    36f6:	89 f7                	mov    %esi,%edi
    36f8:	29 c7                	sub    %eax,%edi
    36fa:	bb 67 66 66 66       	mov    $0x66666667,%ebx
    36ff:	89 f8                	mov    %edi,%eax
    3701:	f7 eb                	imul   %ebx
    3703:	c1 fa 02             	sar    $0x2,%edx
    3706:	c1 ff 1f             	sar    $0x1f,%edi
    3709:	29 fa                	sub    %edi,%edx
    370b:	83 c2 30             	add    $0x30,%edx
    370e:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3711:	89 f0                	mov    %esi,%eax
    3713:	f7 eb                	imul   %ebx
    3715:	c1 fa 02             	sar    $0x2,%edx
    3718:	29 ca                	sub    %ecx,%edx
    371a:	8d 04 92             	lea    (%edx,%edx,4),%eax
    371d:	d1 e0                	shl    %eax
    371f:	89 f2                	mov    %esi,%edx
    3721:	29 c2                	sub    %eax,%edx
    3723:	89 d0                	mov    %edx,%eax
    3725:	83 c0 30             	add    $0x30,%eax
    3728:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    372b:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    unlink(name);
    372f:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3732:	89 04 24             	mov    %eax,(%esp)
    3735:	e8 6d 03 00 00       	call   3aa7 <unlink>
    nfiles--;
    373a:	4e                   	dec    %esi
  while(nfiles >= 0){
    373b:	83 fe ff             	cmp    $0xffffffff,%esi
    373e:	0f 85 48 ff ff ff    	jne    368c <fsfull+0x160>
  printf(1, "fsfull test finished\n");
    3744:	c7 44 24 04 60 4e 00 	movl   $0x4e60,0x4(%esp)
    374b:	00 
    374c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3753:	e8 48 04 00 00       	call   3ba0 <printf>
}
    3758:	83 c4 6c             	add    $0x6c,%esp
    375b:	5b                   	pop    %ebx
    375c:	5e                   	pop    %esi
    375d:	5f                   	pop    %edi
    375e:	5d                   	pop    %ebp
    375f:	c3                   	ret    

00003760 <uio>:
{
    3760:	55                   	push   %ebp
    3761:	89 e5                	mov    %esp,%ebp
    3763:	83 ec 18             	sub    $0x18,%esp
  printf(1, "uio test\n");
    3766:	c7 44 24 04 76 4e 00 	movl   $0x4e76,0x4(%esp)
    376d:	00 
    376e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3775:	e8 26 04 00 00       	call   3ba0 <printf>
  pid = fork();
    377a:	e8 d0 02 00 00       	call   3a4f <fork>
  if(pid == 0){
    377f:	83 f8 00             	cmp    $0x0,%eax
    3782:	74 1d                	je     37a1 <uio+0x41>
  } else if(pid < 0){
    3784:	7c 3f                	jl     37c5 <uio+0x65>
  wait();
    3786:	e8 d4 02 00 00       	call   3a5f <wait>
  printf(1, "uio test done\n");
    378b:	c7 44 24 04 80 4e 00 	movl   $0x4e80,0x4(%esp)
    3792:	00 
    3793:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    379a:	e8 01 04 00 00       	call   3ba0 <printf>
}
    379f:	c9                   	leave  
    37a0:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    37a1:	ba 70 00 00 00       	mov    $0x70,%edx
    37a6:	b0 09                	mov    $0x9,%al
    37a8:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    37a9:	b2 71                	mov    $0x71,%dl
    37ab:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    37ac:	c7 44 24 04 0c 56 00 	movl   $0x560c,0x4(%esp)
    37b3:	00 
    37b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    37bb:	e8 e0 03 00 00       	call   3ba0 <printf>
    exit();
    37c0:	e8 92 02 00 00       	call   3a57 <exit>
    printf (1, "fork failed\n");
    37c5:	c7 44 24 04 05 4e 00 	movl   $0x4e05,0x4(%esp)
    37cc:	00 
    37cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    37d4:	e8 c7 03 00 00       	call   3ba0 <printf>
    exit();
    37d9:	e8 79 02 00 00       	call   3a57 <exit>
    37de:	66 90                	xchg   %ax,%ax

000037e0 <argptest>:
{
    37e0:	55                   	push   %ebp
    37e1:	89 e5                	mov    %esp,%ebp
    37e3:	53                   	push   %ebx
    37e4:	83 ec 14             	sub    $0x14,%esp
  fd = open("init", O_RDONLY);
    37e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    37ee:	00 
    37ef:	c7 04 24 8f 4e 00 00 	movl   $0x4e8f,(%esp)
    37f6:	e8 9c 02 00 00       	call   3a97 <open>
    37fb:	89 c3                	mov    %eax,%ebx
  if (fd < 0) {
    37fd:	85 c0                	test   %eax,%eax
    37ff:	78 43                	js     3844 <argptest+0x64>
  read(fd, sbrk(0) - 1, -1);
    3801:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3808:	e8 da 02 00 00       	call   3ae7 <sbrk>
    380d:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
    3814:	ff 
    3815:	48                   	dec    %eax
    3816:	89 44 24 04          	mov    %eax,0x4(%esp)
    381a:	89 1c 24             	mov    %ebx,(%esp)
    381d:	e8 4d 02 00 00       	call   3a6f <read>
  close(fd);
    3822:	89 1c 24             	mov    %ebx,(%esp)
    3825:	e8 55 02 00 00       	call   3a7f <close>
  printf(1, "arg test passed\n");
    382a:	c7 44 24 04 a1 4e 00 	movl   $0x4ea1,0x4(%esp)
    3831:	00 
    3832:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3839:	e8 62 03 00 00       	call   3ba0 <printf>
}
    383e:	83 c4 14             	add    $0x14,%esp
    3841:	5b                   	pop    %ebx
    3842:	5d                   	pop    %ebp
    3843:	c3                   	ret    
    printf(2, "open failed\n");
    3844:	c7 44 24 04 94 4e 00 	movl   $0x4e94,0x4(%esp)
    384b:	00 
    384c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    3853:	e8 48 03 00 00       	call   3ba0 <printf>
    exit();
    3858:	e8 fa 01 00 00       	call   3a57 <exit>
    385d:	8d 76 00             	lea    0x0(%esi),%esi

00003860 <rand>:
{
    3860:	55                   	push   %ebp
    3861:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3863:	a1 5c 5f 00 00       	mov    0x5f5c,%eax
    3868:	8d 14 40             	lea    (%eax,%eax,2),%edx
    386b:	8d 14 90             	lea    (%eax,%edx,4),%edx
    386e:	c1 e2 08             	shl    $0x8,%edx
    3871:	01 c2                	add    %eax,%edx
    3873:	8d 14 92             	lea    (%edx,%edx,4),%edx
    3876:	8d 04 90             	lea    (%eax,%edx,4),%eax
    3879:	8d 04 80             	lea    (%eax,%eax,4),%eax
    387c:	8d 84 80 5f f3 6e 3c 	lea    0x3c6ef35f(%eax,%eax,4),%eax
    3883:	a3 5c 5f 00 00       	mov    %eax,0x5f5c
}
    3888:	5d                   	pop    %ebp
    3889:	c3                   	ret    
    388a:	66 90                	xchg   %ax,%ax

0000388c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    388c:	55                   	push   %ebp
    388d:	89 e5                	mov    %esp,%ebp
    388f:	53                   	push   %ebx
    3890:	8b 45 08             	mov    0x8(%ebp),%eax
    3893:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3896:	89 c2                	mov    %eax,%edx
    3898:	8a 19                	mov    (%ecx),%bl
    389a:	88 1a                	mov    %bl,(%edx)
    389c:	42                   	inc    %edx
    389d:	41                   	inc    %ecx
    389e:	84 db                	test   %bl,%bl
    38a0:	75 f6                	jne    3898 <strcpy+0xc>
    ;
  return os;
}
    38a2:	5b                   	pop    %ebx
    38a3:	5d                   	pop    %ebp
    38a4:	c3                   	ret    
    38a5:	8d 76 00             	lea    0x0(%esi),%esi

000038a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    38a8:	55                   	push   %ebp
    38a9:	89 e5                	mov    %esp,%ebp
    38ab:	56                   	push   %esi
    38ac:	53                   	push   %ebx
    38ad:	8b 55 08             	mov    0x8(%ebp),%edx
    38b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    38b3:	0f b6 02             	movzbl (%edx),%eax
    38b6:	0f b6 19             	movzbl (%ecx),%ebx
    38b9:	84 c0                	test   %al,%al
    38bb:	75 14                	jne    38d1 <strcmp+0x29>
    38bd:	eb 1d                	jmp    38dc <strcmp+0x34>
    38bf:	90                   	nop
    p++, q++;
    38c0:	42                   	inc    %edx
    38c1:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
    38c4:	0f b6 02             	movzbl (%edx),%eax
    38c7:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
    38cb:	84 c0                	test   %al,%al
    38cd:	74 0d                	je     38dc <strcmp+0x34>
    p++, q++;
    38cf:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
    38d1:	38 d8                	cmp    %bl,%al
    38d3:	74 eb                	je     38c0 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
    38d5:	29 d8                	sub    %ebx,%eax
}
    38d7:	5b                   	pop    %ebx
    38d8:	5e                   	pop    %esi
    38d9:	5d                   	pop    %ebp
    38da:	c3                   	ret    
    38db:	90                   	nop
  while(*p && *p == *q)
    38dc:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    38de:	29 d8                	sub    %ebx,%eax
}
    38e0:	5b                   	pop    %ebx
    38e1:	5e                   	pop    %esi
    38e2:	5d                   	pop    %ebp
    38e3:	c3                   	ret    

000038e4 <strlen>:

uint
strlen(char *s)
{
    38e4:	55                   	push   %ebp
    38e5:	89 e5                	mov    %esp,%ebp
    38e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    38ea:	80 39 00             	cmpb   $0x0,(%ecx)
    38ed:	74 10                	je     38ff <strlen+0x1b>
    38ef:	31 d2                	xor    %edx,%edx
    38f1:	8d 76 00             	lea    0x0(%esi),%esi
    38f4:	42                   	inc    %edx
    38f5:	89 d0                	mov    %edx,%eax
    38f7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    38fb:	75 f7                	jne    38f4 <strlen+0x10>
    ;
  return n;
}
    38fd:	5d                   	pop    %ebp
    38fe:	c3                   	ret    
  for(n = 0; s[n]; n++)
    38ff:	31 c0                	xor    %eax,%eax
}
    3901:	5d                   	pop    %ebp
    3902:	c3                   	ret    
    3903:	90                   	nop

00003904 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3904:	55                   	push   %ebp
    3905:	89 e5                	mov    %esp,%ebp
    3907:	57                   	push   %edi
    3908:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    390b:	89 d7                	mov    %edx,%edi
    390d:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3910:	8b 45 0c             	mov    0xc(%ebp),%eax
    3913:	fc                   	cld    
    3914:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3916:	89 d0                	mov    %edx,%eax
    3918:	5f                   	pop    %edi
    3919:	5d                   	pop    %ebp
    391a:	c3                   	ret    
    391b:	90                   	nop

0000391c <strchr>:

char*
strchr(const char *s, char c)
{
    391c:	55                   	push   %ebp
    391d:	89 e5                	mov    %esp,%ebp
    391f:	8b 45 08             	mov    0x8(%ebp),%eax
    3922:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
    3925:	8a 10                	mov    (%eax),%dl
    3927:	84 d2                	test   %dl,%dl
    3929:	75 0c                	jne    3937 <strchr+0x1b>
    392b:	eb 13                	jmp    3940 <strchr+0x24>
    392d:	8d 76 00             	lea    0x0(%esi),%esi
    3930:	40                   	inc    %eax
    3931:	8a 10                	mov    (%eax),%dl
    3933:	84 d2                	test   %dl,%dl
    3935:	74 09                	je     3940 <strchr+0x24>
    if(*s == c)
    3937:	38 ca                	cmp    %cl,%dl
    3939:	75 f5                	jne    3930 <strchr+0x14>
      return (char*)s;
  return 0;
}
    393b:	5d                   	pop    %ebp
    393c:	c3                   	ret    
    393d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
    3940:	31 c0                	xor    %eax,%eax
}
    3942:	5d                   	pop    %ebp
    3943:	c3                   	ret    

00003944 <gets>:

char*
gets(char *buf, int max)
{
    3944:	55                   	push   %ebp
    3945:	89 e5                	mov    %esp,%ebp
    3947:	57                   	push   %edi
    3948:	56                   	push   %esi
    3949:	53                   	push   %ebx
    394a:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    394d:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
    394f:	8d 7d e7             	lea    -0x19(%ebp),%edi
    3952:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
    3954:	8d 73 01             	lea    0x1(%ebx),%esi
    3957:	3b 75 0c             	cmp    0xc(%ebp),%esi
    395a:	7d 40                	jge    399c <gets+0x58>
    cc = read(0, &c, 1);
    395c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3963:	00 
    3964:	89 7c 24 04          	mov    %edi,0x4(%esp)
    3968:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    396f:	e8 fb 00 00 00       	call   3a6f <read>
    if(cc < 1)
    3974:	85 c0                	test   %eax,%eax
    3976:	7e 24                	jle    399c <gets+0x58>
      break;
    buf[i++] = c;
    3978:	8a 45 e7             	mov    -0x19(%ebp),%al
    397b:	8b 55 08             	mov    0x8(%ebp),%edx
    397e:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
    3982:	3c 0a                	cmp    $0xa,%al
    3984:	74 06                	je     398c <gets+0x48>
    3986:	89 f3                	mov    %esi,%ebx
    3988:	3c 0d                	cmp    $0xd,%al
    398a:	75 c8                	jne    3954 <gets+0x10>
      break;
  }
  buf[i] = '\0';
    398c:	8b 45 08             	mov    0x8(%ebp),%eax
    398f:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    3993:	83 c4 2c             	add    $0x2c,%esp
    3996:	5b                   	pop    %ebx
    3997:	5e                   	pop    %esi
    3998:	5f                   	pop    %edi
    3999:	5d                   	pop    %ebp
    399a:	c3                   	ret    
    399b:	90                   	nop
    if(cc < 1)
    399c:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
    399e:	8b 45 08             	mov    0x8(%ebp),%eax
    39a1:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
    39a5:	83 c4 2c             	add    $0x2c,%esp
    39a8:	5b                   	pop    %ebx
    39a9:	5e                   	pop    %esi
    39aa:	5f                   	pop    %edi
    39ab:	5d                   	pop    %ebp
    39ac:	c3                   	ret    
    39ad:	8d 76 00             	lea    0x0(%esi),%esi

000039b0 <stat>:

int
stat(char *n, struct stat *st)
{
    39b0:	55                   	push   %ebp
    39b1:	89 e5                	mov    %esp,%ebp
    39b3:	56                   	push   %esi
    39b4:	53                   	push   %ebx
    39b5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    39b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    39bf:	00 
    39c0:	8b 45 08             	mov    0x8(%ebp),%eax
    39c3:	89 04 24             	mov    %eax,(%esp)
    39c6:	e8 cc 00 00 00       	call   3a97 <open>
    39cb:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    39cd:	85 c0                	test   %eax,%eax
    39cf:	78 23                	js     39f4 <stat+0x44>
    return -1;
  r = fstat(fd, st);
    39d1:	8b 45 0c             	mov    0xc(%ebp),%eax
    39d4:	89 44 24 04          	mov    %eax,0x4(%esp)
    39d8:	89 1c 24             	mov    %ebx,(%esp)
    39db:	e8 cf 00 00 00       	call   3aaf <fstat>
    39e0:	89 c6                	mov    %eax,%esi
  close(fd);
    39e2:	89 1c 24             	mov    %ebx,(%esp)
    39e5:	e8 95 00 00 00       	call   3a7f <close>
  return r;
}
    39ea:	89 f0                	mov    %esi,%eax
    39ec:	83 c4 10             	add    $0x10,%esp
    39ef:	5b                   	pop    %ebx
    39f0:	5e                   	pop    %esi
    39f1:	5d                   	pop    %ebp
    39f2:	c3                   	ret    
    39f3:	90                   	nop
    return -1;
    39f4:	be ff ff ff ff       	mov    $0xffffffff,%esi
    39f9:	eb ef                	jmp    39ea <stat+0x3a>
    39fb:	90                   	nop

000039fc <atoi>:

int
atoi(const char *s)
{
    39fc:	55                   	push   %ebp
    39fd:	89 e5                	mov    %esp,%ebp
    39ff:	53                   	push   %ebx
    3a00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3a03:	0f be 11             	movsbl (%ecx),%edx
    3a06:	8d 42 d0             	lea    -0x30(%edx),%eax
    3a09:	3c 09                	cmp    $0x9,%al
    3a0b:	b8 00 00 00 00       	mov    $0x0,%eax
    3a10:	77 15                	ja     3a27 <atoi+0x2b>
    3a12:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    3a14:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3a17:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
    3a1b:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
    3a1c:	0f be 11             	movsbl (%ecx),%edx
    3a1f:	8d 5a d0             	lea    -0x30(%edx),%ebx
    3a22:	80 fb 09             	cmp    $0x9,%bl
    3a25:	76 ed                	jbe    3a14 <atoi+0x18>
  return n;
}
    3a27:	5b                   	pop    %ebx
    3a28:	5d                   	pop    %ebp
    3a29:	c3                   	ret    
    3a2a:	66 90                	xchg   %ax,%ax

00003a2c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3a2c:	55                   	push   %ebp
    3a2d:	89 e5                	mov    %esp,%ebp
    3a2f:	56                   	push   %esi
    3a30:	53                   	push   %ebx
    3a31:	8b 45 08             	mov    0x8(%ebp),%eax
    3a34:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    3a37:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
    3a3a:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3a3c:	85 f6                	test   %esi,%esi
    3a3e:	7e 0b                	jle    3a4b <memmove+0x1f>
    *dst++ = *src++;
    3a40:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
    3a43:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    3a46:	42                   	inc    %edx
  while(n-- > 0)
    3a47:	39 f2                	cmp    %esi,%edx
    3a49:	75 f5                	jne    3a40 <memmove+0x14>
  return vdst;
}
    3a4b:	5b                   	pop    %ebx
    3a4c:	5e                   	pop    %esi
    3a4d:	5d                   	pop    %ebp
    3a4e:	c3                   	ret    

00003a4f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3a4f:	b8 01 00 00 00       	mov    $0x1,%eax
    3a54:	cd 40                	int    $0x40
    3a56:	c3                   	ret    

00003a57 <exit>:
SYSCALL(exit)
    3a57:	b8 02 00 00 00       	mov    $0x2,%eax
    3a5c:	cd 40                	int    $0x40
    3a5e:	c3                   	ret    

00003a5f <wait>:
SYSCALL(wait)
    3a5f:	b8 03 00 00 00       	mov    $0x3,%eax
    3a64:	cd 40                	int    $0x40
    3a66:	c3                   	ret    

00003a67 <pipe>:
SYSCALL(pipe)
    3a67:	b8 04 00 00 00       	mov    $0x4,%eax
    3a6c:	cd 40                	int    $0x40
    3a6e:	c3                   	ret    

00003a6f <read>:
SYSCALL(read)
    3a6f:	b8 05 00 00 00       	mov    $0x5,%eax
    3a74:	cd 40                	int    $0x40
    3a76:	c3                   	ret    

00003a77 <write>:
SYSCALL(write)
    3a77:	b8 10 00 00 00       	mov    $0x10,%eax
    3a7c:	cd 40                	int    $0x40
    3a7e:	c3                   	ret    

00003a7f <close>:
SYSCALL(close)
    3a7f:	b8 15 00 00 00       	mov    $0x15,%eax
    3a84:	cd 40                	int    $0x40
    3a86:	c3                   	ret    

00003a87 <kill>:
SYSCALL(kill)
    3a87:	b8 06 00 00 00       	mov    $0x6,%eax
    3a8c:	cd 40                	int    $0x40
    3a8e:	c3                   	ret    

00003a8f <exec>:
SYSCALL(exec)
    3a8f:	b8 07 00 00 00       	mov    $0x7,%eax
    3a94:	cd 40                	int    $0x40
    3a96:	c3                   	ret    

00003a97 <open>:
SYSCALL(open)
    3a97:	b8 0f 00 00 00       	mov    $0xf,%eax
    3a9c:	cd 40                	int    $0x40
    3a9e:	c3                   	ret    

00003a9f <mknod>:
SYSCALL(mknod)
    3a9f:	b8 11 00 00 00       	mov    $0x11,%eax
    3aa4:	cd 40                	int    $0x40
    3aa6:	c3                   	ret    

00003aa7 <unlink>:
SYSCALL(unlink)
    3aa7:	b8 12 00 00 00       	mov    $0x12,%eax
    3aac:	cd 40                	int    $0x40
    3aae:	c3                   	ret    

00003aaf <fstat>:
SYSCALL(fstat)
    3aaf:	b8 08 00 00 00       	mov    $0x8,%eax
    3ab4:	cd 40                	int    $0x40
    3ab6:	c3                   	ret    

00003ab7 <link>:
SYSCALL(link)
    3ab7:	b8 13 00 00 00       	mov    $0x13,%eax
    3abc:	cd 40                	int    $0x40
    3abe:	c3                   	ret    

00003abf <mkdir>:
SYSCALL(mkdir)
    3abf:	b8 14 00 00 00       	mov    $0x14,%eax
    3ac4:	cd 40                	int    $0x40
    3ac6:	c3                   	ret    

00003ac7 <chdir>:
SYSCALL(chdir)
    3ac7:	b8 09 00 00 00       	mov    $0x9,%eax
    3acc:	cd 40                	int    $0x40
    3ace:	c3                   	ret    

00003acf <dup>:
SYSCALL(dup)
    3acf:	b8 0a 00 00 00       	mov    $0xa,%eax
    3ad4:	cd 40                	int    $0x40
    3ad6:	c3                   	ret    

00003ad7 <getpid>:
SYSCALL(getpid)
    3ad7:	b8 0b 00 00 00       	mov    $0xb,%eax
    3adc:	cd 40                	int    $0x40
    3ade:	c3                   	ret    

00003adf <getppid>:
SYSCALL(getppid)
    3adf:	b8 17 00 00 00       	mov    $0x17,%eax
    3ae4:	cd 40                	int    $0x40
    3ae6:	c3                   	ret    

00003ae7 <sbrk>:
SYSCALL(sbrk)
    3ae7:	b8 0c 00 00 00       	mov    $0xc,%eax
    3aec:	cd 40                	int    $0x40
    3aee:	c3                   	ret    

00003aef <sleep>:
SYSCALL(sleep)
    3aef:	b8 0d 00 00 00       	mov    $0xd,%eax
    3af4:	cd 40                	int    $0x40
    3af6:	c3                   	ret    

00003af7 <uptime>:
SYSCALL(uptime)
    3af7:	b8 0e 00 00 00       	mov    $0xe,%eax
    3afc:	cd 40                	int    $0x40
    3afe:	c3                   	ret    

00003aff <myfunction>:
SYSCALL(myfunction)
    3aff:	b8 16 00 00 00       	mov    $0x16,%eax
    3b04:	cd 40                	int    $0x40
    3b06:	c3                   	ret    

00003b07 <yield>:
SYSCALL(yield)
    3b07:	b8 18 00 00 00       	mov    $0x18,%eax
    3b0c:	cd 40                	int    $0x40
    3b0e:	c3                   	ret    

00003b0f <getlev>:
SYSCALL(getlev)
    3b0f:	b8 19 00 00 00       	mov    $0x19,%eax
    3b14:	cd 40                	int    $0x40
    3b16:	c3                   	ret    

00003b17 <set_cpu_share>:
    3b17:	b8 1a 00 00 00       	mov    $0x1a,%eax
    3b1c:	cd 40                	int    $0x40
    3b1e:	c3                   	ret    
    3b1f:	90                   	nop

00003b20 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    3b20:	55                   	push   %ebp
    3b21:	89 e5                	mov    %esp,%ebp
    3b23:	57                   	push   %edi
    3b24:	56                   	push   %esi
    3b25:	53                   	push   %ebx
    3b26:	83 ec 3c             	sub    $0x3c,%esp
    3b29:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    3b2b:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
    3b2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3b30:	85 db                	test   %ebx,%ebx
    3b32:	74 04                	je     3b38 <printint+0x18>
    3b34:	85 d2                	test   %edx,%edx
    3b36:	78 5d                	js     3b95 <printint+0x75>
  neg = 0;
    3b38:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
    3b3a:	31 f6                	xor    %esi,%esi
    3b3c:	eb 04                	jmp    3b42 <printint+0x22>
    3b3e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
    3b40:	89 d6                	mov    %edx,%esi
    3b42:	31 d2                	xor    %edx,%edx
    3b44:	f7 f1                	div    %ecx
    3b46:	8a 92 73 56 00 00    	mov    0x5673(%edx),%dl
    3b4c:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
    3b50:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
    3b53:	85 c0                	test   %eax,%eax
    3b55:	75 e9                	jne    3b40 <printint+0x20>
  if(neg)
    3b57:	85 db                	test   %ebx,%ebx
    3b59:	74 08                	je     3b63 <printint+0x43>
    buf[i++] = '-';
    3b5b:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
    3b60:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
    3b63:	8d 5a ff             	lea    -0x1(%edx),%ebx
    3b66:	8d 75 d7             	lea    -0x29(%ebp),%esi
    3b69:	8d 76 00             	lea    0x0(%esi),%esi
    3b6c:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
    3b70:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
    3b73:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3b7a:	00 
    3b7b:	89 74 24 04          	mov    %esi,0x4(%esp)
    3b7f:	89 3c 24             	mov    %edi,(%esp)
    3b82:	e8 f0 fe ff ff       	call   3a77 <write>
  while(--i >= 0)
    3b87:	4b                   	dec    %ebx
    3b88:	83 fb ff             	cmp    $0xffffffff,%ebx
    3b8b:	75 df                	jne    3b6c <printint+0x4c>
    putc(fd, buf[i]);
}
    3b8d:	83 c4 3c             	add    $0x3c,%esp
    3b90:	5b                   	pop    %ebx
    3b91:	5e                   	pop    %esi
    3b92:	5f                   	pop    %edi
    3b93:	5d                   	pop    %ebp
    3b94:	c3                   	ret    
    x = -xx;
    3b95:	f7 d8                	neg    %eax
    neg = 1;
    3b97:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
    3b9c:	eb 9c                	jmp    3b3a <printint+0x1a>
    3b9e:	66 90                	xchg   %ax,%ax

00003ba0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    3ba0:	55                   	push   %ebp
    3ba1:	89 e5                	mov    %esp,%ebp
    3ba3:	57                   	push   %edi
    3ba4:	56                   	push   %esi
    3ba5:	53                   	push   %ebx
    3ba6:	83 ec 3c             	sub    $0x3c,%esp
    3ba9:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3bac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    3baf:	8a 03                	mov    (%ebx),%al
    3bb1:	84 c0                	test   %al,%al
    3bb3:	0f 84 bb 00 00 00    	je     3c74 <printf+0xd4>
printf(int fd, char *fmt, ...)
    3bb9:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
    3bba:	8d 55 10             	lea    0x10(%ebp),%edx
    3bbd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
    3bc0:	31 ff                	xor    %edi,%edi
    3bc2:	eb 2f                	jmp    3bf3 <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    3bc4:	83 f9 25             	cmp    $0x25,%ecx
    3bc7:	0f 84 af 00 00 00    	je     3c7c <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
    3bcd:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
    3bd0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3bd7:	00 
    3bd8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    3bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
    3bdf:	89 34 24             	mov    %esi,(%esp)
    3be2:	e8 90 fe ff ff       	call   3a77 <write>
    3be7:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
    3be8:	8a 43 ff             	mov    -0x1(%ebx),%al
    3beb:	84 c0                	test   %al,%al
    3bed:	0f 84 81 00 00 00    	je     3c74 <printf+0xd4>
    c = fmt[i] & 0xff;
    3bf3:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
    3bf6:	85 ff                	test   %edi,%edi
    3bf8:	74 ca                	je     3bc4 <printf+0x24>
      }
    } else if(state == '%'){
    3bfa:	83 ff 25             	cmp    $0x25,%edi
    3bfd:	75 e8                	jne    3be7 <printf+0x47>
      if(c == 'd'){
    3bff:	83 f9 64             	cmp    $0x64,%ecx
    3c02:	0f 84 14 01 00 00    	je     3d1c <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    3c08:	83 f9 78             	cmp    $0x78,%ecx
    3c0b:	74 7b                	je     3c88 <printf+0xe8>
    3c0d:	83 f9 70             	cmp    $0x70,%ecx
    3c10:	74 76                	je     3c88 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    3c12:	83 f9 73             	cmp    $0x73,%ecx
    3c15:	0f 84 91 00 00 00    	je     3cac <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3c1b:	83 f9 63             	cmp    $0x63,%ecx
    3c1e:	0f 84 cc 00 00 00    	je     3cf0 <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3c24:	83 f9 25             	cmp    $0x25,%ecx
    3c27:	0f 84 13 01 00 00    	je     3d40 <printf+0x1a0>
    3c2d:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
    3c31:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3c38:	00 
    3c39:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    3c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
    3c40:	89 34 24             	mov    %esi,(%esp)
    3c43:	89 4d d0             	mov    %ecx,-0x30(%ebp)
    3c46:	e8 2c fe ff ff       	call   3a77 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    3c4b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
    3c4e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
    3c51:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3c58:	00 
    3c59:	8d 55 e7             	lea    -0x19(%ebp),%edx
    3c5c:	89 54 24 04          	mov    %edx,0x4(%esp)
    3c60:	89 34 24             	mov    %esi,(%esp)
    3c63:	e8 0f fe ff ff       	call   3a77 <write>
      }
      state = 0;
    3c68:	31 ff                	xor    %edi,%edi
    3c6a:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
    3c6b:	8a 43 ff             	mov    -0x1(%ebx),%al
    3c6e:	84 c0                	test   %al,%al
    3c70:	75 81                	jne    3bf3 <printf+0x53>
    3c72:	66 90                	xchg   %ax,%ax
    }
  }
}
    3c74:	83 c4 3c             	add    $0x3c,%esp
    3c77:	5b                   	pop    %ebx
    3c78:	5e                   	pop    %esi
    3c79:	5f                   	pop    %edi
    3c7a:	5d                   	pop    %ebp
    3c7b:	c3                   	ret    
        state = '%';
    3c7c:	bf 25 00 00 00       	mov    $0x25,%edi
    3c81:	e9 61 ff ff ff       	jmp    3be7 <printf+0x47>
    3c86:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    3c88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3c8f:	b9 10 00 00 00       	mov    $0x10,%ecx
    3c94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3c97:	8b 10                	mov    (%eax),%edx
    3c99:	89 f0                	mov    %esi,%eax
    3c9b:	e8 80 fe ff ff       	call   3b20 <printint>
        ap++;
    3ca0:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
    3ca4:	31 ff                	xor    %edi,%edi
        ap++;
    3ca6:	e9 3c ff ff ff       	jmp    3be7 <printf+0x47>
    3cab:	90                   	nop
        s = (char*)*ap;
    3cac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    3caf:	8b 3a                	mov    (%edx),%edi
        ap++;
    3cb1:	83 c2 04             	add    $0x4,%edx
    3cb4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
    3cb7:	85 ff                	test   %edi,%edi
    3cb9:	0f 84 a3 00 00 00    	je     3d62 <printf+0x1c2>
        while(*s != 0){
    3cbf:	8a 07                	mov    (%edi),%al
    3cc1:	84 c0                	test   %al,%al
    3cc3:	74 24                	je     3ce9 <printf+0x149>
    3cc5:	8d 76 00             	lea    0x0(%esi),%esi
    3cc8:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    3ccb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3cd2:	00 
    3cd3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
    3cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
    3cda:	89 34 24             	mov    %esi,(%esp)
    3cdd:	e8 95 fd ff ff       	call   3a77 <write>
          s++;
    3ce2:	47                   	inc    %edi
        while(*s != 0){
    3ce3:	8a 07                	mov    (%edi),%al
    3ce5:	84 c0                	test   %al,%al
    3ce7:	75 df                	jne    3cc8 <printf+0x128>
      state = 0;
    3ce9:	31 ff                	xor    %edi,%edi
    3ceb:	e9 f7 fe ff ff       	jmp    3be7 <printf+0x47>
        putc(fd, *ap);
    3cf0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    3cf3:	8b 02                	mov    (%edx),%eax
    3cf5:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    3cf8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3cff:	00 
    3d00:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    3d03:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d07:	89 34 24             	mov    %esi,(%esp)
    3d0a:	e8 68 fd ff ff       	call   3a77 <write>
        ap++;
    3d0f:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
    3d13:	31 ff                	xor    %edi,%edi
    3d15:	e9 cd fe ff ff       	jmp    3be7 <printf+0x47>
    3d1a:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    3d1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3d23:	b1 0a                	mov    $0xa,%cl
    3d25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3d28:	8b 10                	mov    (%eax),%edx
    3d2a:	89 f0                	mov    %esi,%eax
    3d2c:	e8 ef fd ff ff       	call   3b20 <printint>
        ap++;
    3d31:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
    3d35:	66 31 ff             	xor    %di,%di
    3d38:	e9 aa fe ff ff       	jmp    3be7 <printf+0x47>
    3d3d:	8d 76 00             	lea    0x0(%esi),%esi
    3d40:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
    3d44:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3d4b:	00 
    3d4c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    3d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d53:	89 34 24             	mov    %esi,(%esp)
    3d56:	e8 1c fd ff ff       	call   3a77 <write>
      state = 0;
    3d5b:	31 ff                	xor    %edi,%edi
    3d5d:	e9 85 fe ff ff       	jmp    3be7 <printf+0x47>
          s = "(null)";
    3d62:	bf 6c 56 00 00       	mov    $0x566c,%edi
    3d67:	e9 53 ff ff ff       	jmp    3cbf <printf+0x11f>

00003d6c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3d6c:	55                   	push   %ebp
    3d6d:	89 e5                	mov    %esp,%ebp
    3d6f:	57                   	push   %edi
    3d70:	56                   	push   %esi
    3d71:	53                   	push   %ebx
    3d72:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3d75:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3d78:	a1 00 60 00 00       	mov    0x6000,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3d7d:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3d7f:	39 d0                	cmp    %edx,%eax
    3d81:	72 11                	jb     3d94 <free+0x28>
    3d83:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3d84:	39 c8                	cmp    %ecx,%eax
    3d86:	72 04                	jb     3d8c <free+0x20>
    3d88:	39 ca                	cmp    %ecx,%edx
    3d8a:	72 10                	jb     3d9c <free+0x30>
    3d8c:	89 c8                	mov    %ecx,%eax
    3d8e:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3d90:	39 d0                	cmp    %edx,%eax
    3d92:	73 f0                	jae    3d84 <free+0x18>
    3d94:	39 ca                	cmp    %ecx,%edx
    3d96:	72 04                	jb     3d9c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3d98:	39 c8                	cmp    %ecx,%eax
    3d9a:	72 f0                	jb     3d8c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3d9c:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3d9f:	8d 3c f2             	lea    (%edx,%esi,8),%edi
    3da2:	39 cf                	cmp    %ecx,%edi
    3da4:	74 1a                	je     3dc0 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3da6:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3da9:	8b 48 04             	mov    0x4(%eax),%ecx
    3dac:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    3daf:	39 f2                	cmp    %esi,%edx
    3db1:	74 24                	je     3dd7 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3db3:	89 10                	mov    %edx,(%eax)
  freep = p;
    3db5:	a3 00 60 00 00       	mov    %eax,0x6000
}
    3dba:	5b                   	pop    %ebx
    3dbb:	5e                   	pop    %esi
    3dbc:	5f                   	pop    %edi
    3dbd:	5d                   	pop    %ebp
    3dbe:	c3                   	ret    
    3dbf:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    3dc0:	03 71 04             	add    0x4(%ecx),%esi
    3dc3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3dc6:	8b 08                	mov    (%eax),%ecx
    3dc8:	8b 09                	mov    (%ecx),%ecx
    3dca:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3dcd:	8b 48 04             	mov    0x4(%eax),%ecx
    3dd0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    3dd3:	39 f2                	cmp    %esi,%edx
    3dd5:	75 dc                	jne    3db3 <free+0x47>
    p->s.size += bp->s.size;
    3dd7:	03 4b fc             	add    -0x4(%ebx),%ecx
    3dda:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3ddd:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3de0:	89 10                	mov    %edx,(%eax)
  freep = p;
    3de2:	a3 00 60 00 00       	mov    %eax,0x6000
}
    3de7:	5b                   	pop    %ebx
    3de8:	5e                   	pop    %esi
    3de9:	5f                   	pop    %edi
    3dea:	5d                   	pop    %ebp
    3deb:	c3                   	ret    

00003dec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3dec:	55                   	push   %ebp
    3ded:	89 e5                	mov    %esp,%ebp
    3def:	57                   	push   %edi
    3df0:	56                   	push   %esi
    3df1:	53                   	push   %ebx
    3df2:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3df5:	8b 75 08             	mov    0x8(%ebp),%esi
    3df8:	83 c6 07             	add    $0x7,%esi
    3dfb:	c1 ee 03             	shr    $0x3,%esi
    3dfe:	46                   	inc    %esi
  if((prevp = freep) == 0){
    3dff:	8b 15 00 60 00 00    	mov    0x6000,%edx
    3e05:	85 d2                	test   %edx,%edx
    3e07:	0f 84 8d 00 00 00    	je     3e9a <malloc+0xae>
    3e0d:	8b 02                	mov    (%edx),%eax
    3e0f:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    3e12:	39 ce                	cmp    %ecx,%esi
    3e14:	76 52                	jbe    3e68 <malloc+0x7c>
    3e16:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
    3e1d:	eb 0a                	jmp    3e29 <malloc+0x3d>
    3e1f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3e20:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    3e22:	8b 48 04             	mov    0x4(%eax),%ecx
    3e25:	39 ce                	cmp    %ecx,%esi
    3e27:	76 3f                	jbe    3e68 <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    3e29:	89 c2                	mov    %eax,%edx
    3e2b:	3b 05 00 60 00 00    	cmp    0x6000,%eax
    3e31:	75 ed                	jne    3e20 <malloc+0x34>
  if(nu < 4096)
    3e33:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
    3e39:	76 4d                	jbe    3e88 <malloc+0x9c>
    3e3b:	89 d8                	mov    %ebx,%eax
    3e3d:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
    3e3f:	89 04 24             	mov    %eax,(%esp)
    3e42:	e8 a0 fc ff ff       	call   3ae7 <sbrk>
  if(p == (char*)-1)
    3e47:	83 f8 ff             	cmp    $0xffffffff,%eax
    3e4a:	74 18                	je     3e64 <malloc+0x78>
  hp->s.size = nu;
    3e4c:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    3e4f:	83 c0 08             	add    $0x8,%eax
    3e52:	89 04 24             	mov    %eax,(%esp)
    3e55:	e8 12 ff ff ff       	call   3d6c <free>
  return freep;
    3e5a:	8b 15 00 60 00 00    	mov    0x6000,%edx
      if((p = morecore(nunits)) == 0)
    3e60:	85 d2                	test   %edx,%edx
    3e62:	75 bc                	jne    3e20 <malloc+0x34>
        return 0;
    3e64:	31 c0                	xor    %eax,%eax
    3e66:	eb 18                	jmp    3e80 <malloc+0x94>
      if(p->s.size == nunits)
    3e68:	39 ce                	cmp    %ecx,%esi
    3e6a:	74 28                	je     3e94 <malloc+0xa8>
        p->s.size -= nunits;
    3e6c:	29 f1                	sub    %esi,%ecx
    3e6e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    3e71:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    3e74:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    3e77:	89 15 00 60 00 00    	mov    %edx,0x6000
      return (void*)(p + 1);
    3e7d:	83 c0 08             	add    $0x8,%eax
  }
}
    3e80:	83 c4 1c             	add    $0x1c,%esp
    3e83:	5b                   	pop    %ebx
    3e84:	5e                   	pop    %esi
    3e85:	5f                   	pop    %edi
    3e86:	5d                   	pop    %ebp
    3e87:	c3                   	ret    
  if(nu < 4096)
    3e88:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
    3e8d:	bf 00 10 00 00       	mov    $0x1000,%edi
    3e92:	eb ab                	jmp    3e3f <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
    3e94:	8b 08                	mov    (%eax),%ecx
    3e96:	89 0a                	mov    %ecx,(%edx)
    3e98:	eb dd                	jmp    3e77 <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
    3e9a:	c7 05 00 60 00 00 04 	movl   $0x6004,0x6000
    3ea1:	60 00 00 
    3ea4:	c7 05 04 60 00 00 04 	movl   $0x6004,0x6004
    3eab:	60 00 00 
    base.s.size = 0;
    3eae:	c7 05 08 60 00 00 00 	movl   $0x0,0x6008
    3eb5:	00 00 00 
    3eb8:	b8 04 60 00 00       	mov    $0x6004,%eax
    3ebd:	e9 54 ff ff ff       	jmp    3e16 <malloc+0x2a>
