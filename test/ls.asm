
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 10             	sub    $0x10,%esp
   c:	8b 75 08             	mov    0x8(%ebp),%esi
   f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  if(argc < 2){
  12:	83 fe 01             	cmp    $0x1,%esi
  15:	7e 1a                	jle    31 <main+0x31>
  17:	bb 01 00 00 00       	mov    $0x1,%ebx
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  1c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 b1 00 00 00       	call   d8 <ls>
  for(i=1; i<argc; i++)
  27:	43                   	inc    %ebx
  28:	39 f3                	cmp    %esi,%ebx
  2a:	75 f0                	jne    1c <main+0x1c>
  exit();
  2c:	e8 da 04 00 00       	call   50b <exit>
    ls(".");
  31:	c7 04 24 be 09 00 00 	movl   $0x9be,(%esp)
  38:	e8 9b 00 00 00       	call   d8 <ls>
    exit();
  3d:	e8 c9 04 00 00       	call   50b <exit>
  42:	66 90                	xchg   %ax,%ax

00000044 <fmtname>:
{
  44:	55                   	push   %ebp
  45:	89 e5                	mov    %esp,%ebp
  47:	56                   	push   %esi
  48:	53                   	push   %ebx
  49:	83 ec 10             	sub    $0x10,%esp
  4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  4f:	89 1c 24             	mov    %ebx,(%esp)
  52:	e8 41 03 00 00       	call   398 <strlen>
  57:	01 d8                	add    %ebx,%eax
  59:	73 0a                	jae    65 <fmtname+0x21>
  5b:	eb 0d                	jmp    6a <fmtname+0x26>
  5d:	8d 76 00             	lea    0x0(%esi),%esi
  60:	48                   	dec    %eax
  61:	39 c3                	cmp    %eax,%ebx
  63:	77 05                	ja     6a <fmtname+0x26>
  65:	80 38 2f             	cmpb   $0x2f,(%eax)
  68:	75 f6                	jne    60 <fmtname+0x1c>
  p++;
  6a:	8d 58 01             	lea    0x1(%eax),%ebx
  if(strlen(p) >= DIRSIZ)
  6d:	89 1c 24             	mov    %ebx,(%esp)
  70:	e8 23 03 00 00       	call   398 <strlen>
  75:	83 f8 0d             	cmp    $0xd,%eax
  78:	77 53                	ja     cd <fmtname+0x89>
  memmove(buf, p, strlen(p));
  7a:	89 1c 24             	mov    %ebx,(%esp)
  7d:	e8 16 03 00 00       	call   398 <strlen>
  82:	89 44 24 08          	mov    %eax,0x8(%esp)
  86:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8a:	c7 04 24 c4 0c 00 00 	movl   $0xcc4,(%esp)
  91:	e8 4a 04 00 00       	call   4e0 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  96:	89 1c 24             	mov    %ebx,(%esp)
  99:	e8 fa 02 00 00       	call   398 <strlen>
  9e:	89 c6                	mov    %eax,%esi
  a0:	89 1c 24             	mov    %ebx,(%esp)
  a3:	e8 f0 02 00 00       	call   398 <strlen>
  a8:	ba 0e 00 00 00       	mov    $0xe,%edx
  ad:	29 f2                	sub    %esi,%edx
  af:	89 54 24 08          	mov    %edx,0x8(%esp)
  b3:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  ba:	00 
  bb:	05 c4 0c 00 00       	add    $0xcc4,%eax
  c0:	89 04 24             	mov    %eax,(%esp)
  c3:	e8 f0 02 00 00       	call   3b8 <memset>
  return buf;
  c8:	bb c4 0c 00 00       	mov    $0xcc4,%ebx
}
  cd:	89 d8                	mov    %ebx,%eax
  cf:	83 c4 10             	add    $0x10,%esp
  d2:	5b                   	pop    %ebx
  d3:	5e                   	pop    %esi
  d4:	5d                   	pop    %ebp
  d5:	c3                   	ret    
  d6:	66 90                	xchg   %ax,%ax

000000d8 <ls>:
{
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  db:	57                   	push   %edi
  dc:	56                   	push   %esi
  dd:	53                   	push   %ebx
  de:	81 ec 7c 02 00 00    	sub    $0x27c,%esp
  e4:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
  e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ee:	00 
  ef:	89 3c 24             	mov    %edi,(%esp)
  f2:	e8 54 04 00 00       	call   54b <open>
  f7:	89 c3                	mov    %eax,%ebx
  f9:	85 c0                	test   %eax,%eax
  fb:	0f 88 b3 01 00 00    	js     2b4 <ls+0x1dc>
  if(fstat(fd, &st) < 0){
 101:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 107:	89 74 24 04          	mov    %esi,0x4(%esp)
 10b:	89 04 24             	mov    %eax,(%esp)
 10e:	e8 50 04 00 00       	call   563 <fstat>
 113:	85 c0                	test   %eax,%eax
 115:	0f 88 d9 01 00 00    	js     2f4 <ls+0x21c>
  switch(st.type){
 11b:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 121:	66 83 f8 01          	cmp    $0x1,%ax
 125:	74 61                	je     188 <ls+0xb0>
 127:	66 83 f8 02          	cmp    $0x2,%ax
 12b:	75 48                	jne    175 <ls+0x9d>
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 12d:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 133:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 139:	89 3c 24             	mov    %edi,(%esp)
 13c:	89 95 a8 fd ff ff    	mov    %edx,-0x258(%ebp)
 142:	e8 fd fe ff ff       	call   44 <fmtname>
 147:	8b 95 a8 fd ff ff    	mov    -0x258(%ebp),%edx
 14d:	89 54 24 14          	mov    %edx,0x14(%esp)
 151:	89 74 24 10          	mov    %esi,0x10(%esp)
 155:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
 15c:	00 
 15d:	89 44 24 08          	mov    %eax,0x8(%esp)
 161:	c7 44 24 04 9e 09 00 	movl   $0x99e,0x4(%esp)
 168:	00 
 169:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 170:	e8 df 04 00 00       	call   654 <printf>
  close(fd);
 175:	89 1c 24             	mov    %ebx,(%esp)
 178:	e8 b6 03 00 00       	call   533 <close>
}
 17d:	81 c4 7c 02 00 00    	add    $0x27c,%esp
 183:	5b                   	pop    %ebx
 184:	5e                   	pop    %esi
 185:	5f                   	pop    %edi
 186:	5d                   	pop    %ebp
 187:	c3                   	ret    
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 188:	89 3c 24             	mov    %edi,(%esp)
 18b:	e8 08 02 00 00       	call   398 <strlen>
 190:	83 c0 10             	add    $0x10,%eax
 193:	3d 00 02 00 00       	cmp    $0x200,%eax
 198:	0f 87 3a 01 00 00    	ja     2d8 <ls+0x200>
    strcpy(buf, path);
 19e:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1a2:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1a8:	89 04 24             	mov    %eax,(%esp)
 1ab:	e8 90 01 00 00       	call   340 <strcpy>
    p = buf+strlen(buf);
 1b0:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
 1b6:	89 14 24             	mov    %edx,(%esp)
 1b9:	e8 da 01 00 00       	call   398 <strlen>
 1be:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
 1c4:	01 c1                	add    %eax,%ecx
 1c6:	89 8d b4 fd ff ff    	mov    %ecx,-0x24c(%ebp)
    *p++ = '/';
 1cc:	c6 01 2f             	movb   $0x2f,(%ecx)
 1cf:	41                   	inc    %ecx
 1d0:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 1d6:	8d bd c4 fd ff ff    	lea    -0x23c(%ebp),%edi
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1dc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 1e3:	00 
 1e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1e8:	89 1c 24             	mov    %ebx,(%esp)
 1eb:	e8 33 03 00 00       	call   523 <read>
 1f0:	83 f8 10             	cmp    $0x10,%eax
 1f3:	75 80                	jne    175 <ls+0x9d>
      if(de.inum == 0)
 1f5:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 1fc:	00 
 1fd:	74 dd                	je     1dc <ls+0x104>
      memmove(p, de.name, DIRSIZ);
 1ff:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 206:	00 
 207:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 20d:	89 44 24 04          	mov    %eax,0x4(%esp)
 211:	8b 95 ac fd ff ff    	mov    -0x254(%ebp),%edx
 217:	89 14 24             	mov    %edx,(%esp)
 21a:	e8 c1 02 00 00       	call   4e0 <memmove>
      p[DIRSIZ] = 0;
 21f:	8b 8d b4 fd ff ff    	mov    -0x24c(%ebp),%ecx
 225:	c6 41 0f 00          	movb   $0x0,0xf(%ecx)
      if(stat(buf, &st) < 0){
 229:	89 74 24 04          	mov    %esi,0x4(%esp)
 22d:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 233:	89 04 24             	mov    %eax,(%esp)
 236:	e8 29 02 00 00       	call   464 <stat>
 23b:	85 c0                	test   %eax,%eax
 23d:	0f 88 d9 00 00 00    	js     31c <ls+0x244>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 243:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 249:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 24f:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 255:	0f bf 95 d4 fd ff ff 	movswl -0x22c(%ebp),%edx
 25c:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 262:	89 04 24             	mov    %eax,(%esp)
 265:	89 95 a8 fd ff ff    	mov    %edx,-0x258(%ebp)
 26b:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
 271:	e8 ce fd ff ff       	call   44 <fmtname>
 276:	8b 8d a4 fd ff ff    	mov    -0x25c(%ebp),%ecx
 27c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
 280:	8b 8d b0 fd ff ff    	mov    -0x250(%ebp),%ecx
 286:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 28a:	8b 95 a8 fd ff ff    	mov    -0x258(%ebp),%edx
 290:	89 54 24 0c          	mov    %edx,0xc(%esp)
 294:	89 44 24 08          	mov    %eax,0x8(%esp)
 298:	c7 44 24 04 9e 09 00 	movl   $0x99e,0x4(%esp)
 29f:	00 
 2a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2a7:	e8 a8 03 00 00       	call   654 <printf>
 2ac:	e9 2b ff ff ff       	jmp    1dc <ls+0x104>
 2b1:	8d 76 00             	lea    0x0(%esi),%esi
    printf(2, "ls: cannot open %s\n", path);
 2b4:	89 7c 24 08          	mov    %edi,0x8(%esp)
 2b8:	c7 44 24 04 76 09 00 	movl   $0x976,0x4(%esp)
 2bf:	00 
 2c0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2c7:	e8 88 03 00 00       	call   654 <printf>
}
 2cc:	81 c4 7c 02 00 00    	add    $0x27c,%esp
 2d2:	5b                   	pop    %ebx
 2d3:	5e                   	pop    %esi
 2d4:	5f                   	pop    %edi
 2d5:	5d                   	pop    %ebp
 2d6:	c3                   	ret    
 2d7:	90                   	nop
      printf(1, "ls: path too long\n");
 2d8:	c7 44 24 04 ab 09 00 	movl   $0x9ab,0x4(%esp)
 2df:	00 
 2e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2e7:	e8 68 03 00 00       	call   654 <printf>
      break;
 2ec:	e9 84 fe ff ff       	jmp    175 <ls+0x9d>
 2f1:	8d 76 00             	lea    0x0(%esi),%esi
    printf(2, "ls: cannot stat %s\n", path);
 2f4:	89 7c 24 08          	mov    %edi,0x8(%esp)
 2f8:	c7 44 24 04 8a 09 00 	movl   $0x98a,0x4(%esp)
 2ff:	00 
 300:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 307:	e8 48 03 00 00       	call   654 <printf>
    close(fd);
 30c:	89 1c 24             	mov    %ebx,(%esp)
 30f:	e8 1f 02 00 00       	call   533 <close>
 314:	e9 64 fe ff ff       	jmp    17d <ls+0xa5>
 319:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "ls: cannot stat %s\n", buf);
 31c:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
 322:	89 54 24 08          	mov    %edx,0x8(%esp)
 326:	c7 44 24 04 8a 09 00 	movl   $0x98a,0x4(%esp)
 32d:	00 
 32e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 335:	e8 1a 03 00 00       	call   654 <printf>
        continue;
 33a:	e9 9d fe ff ff       	jmp    1dc <ls+0x104>
 33f:	90                   	nop

00000340 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 34a:	89 c2                	mov    %eax,%edx
 34c:	8a 19                	mov    (%ecx),%bl
 34e:	88 1a                	mov    %bl,(%edx)
 350:	42                   	inc    %edx
 351:	41                   	inc    %ecx
 352:	84 db                	test   %bl,%bl
 354:	75 f6                	jne    34c <strcpy+0xc>
    ;
  return os;
}
 356:	5b                   	pop    %ebx
 357:	5d                   	pop    %ebp
 358:	c3                   	ret    
 359:	8d 76 00             	lea    0x0(%esi),%esi

0000035c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	56                   	push   %esi
 360:	53                   	push   %ebx
 361:	8b 55 08             	mov    0x8(%ebp),%edx
 364:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 367:	0f b6 02             	movzbl (%edx),%eax
 36a:	0f b6 19             	movzbl (%ecx),%ebx
 36d:	84 c0                	test   %al,%al
 36f:	75 14                	jne    385 <strcmp+0x29>
 371:	eb 1d                	jmp    390 <strcmp+0x34>
 373:	90                   	nop
    p++, q++;
 374:	42                   	inc    %edx
 375:	8d 71 01             	lea    0x1(%ecx),%esi
  while(*p && *p == *q)
 378:	0f b6 02             	movzbl (%edx),%eax
 37b:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 37f:	84 c0                	test   %al,%al
 381:	74 0d                	je     390 <strcmp+0x34>
    p++, q++;
 383:	89 f1                	mov    %esi,%ecx
  while(*p && *p == *q)
 385:	38 d8                	cmp    %bl,%al
 387:	74 eb                	je     374 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 389:	29 d8                	sub    %ebx,%eax
}
 38b:	5b                   	pop    %ebx
 38c:	5e                   	pop    %esi
 38d:	5d                   	pop    %ebp
 38e:	c3                   	ret    
 38f:	90                   	nop
  while(*p && *p == *q)
 390:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 392:	29 d8                	sub    %ebx,%eax
}
 394:	5b                   	pop    %ebx
 395:	5e                   	pop    %esi
 396:	5d                   	pop    %ebp
 397:	c3                   	ret    

00000398 <strlen>:

uint
strlen(char *s)
{
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
 39b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 39e:	80 39 00             	cmpb   $0x0,(%ecx)
 3a1:	74 10                	je     3b3 <strlen+0x1b>
 3a3:	31 d2                	xor    %edx,%edx
 3a5:	8d 76 00             	lea    0x0(%esi),%esi
 3a8:	42                   	inc    %edx
 3a9:	89 d0                	mov    %edx,%eax
 3ab:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3af:	75 f7                	jne    3a8 <strlen+0x10>
    ;
  return n;
}
 3b1:	5d                   	pop    %ebp
 3b2:	c3                   	ret    
  for(n = 0; s[n]; n++)
 3b3:	31 c0                	xor    %eax,%eax
}
 3b5:	5d                   	pop    %ebp
 3b6:	c3                   	ret    
 3b7:	90                   	nop

000003b8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3b8:	55                   	push   %ebp
 3b9:	89 e5                	mov    %esp,%ebp
 3bb:	57                   	push   %edi
 3bc:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3bf:	89 d7                	mov    %edx,%edi
 3c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c7:	fc                   	cld    
 3c8:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3ca:	89 d0                	mov    %edx,%eax
 3cc:	5f                   	pop    %edi
 3cd:	5d                   	pop    %ebp
 3ce:	c3                   	ret    
 3cf:	90                   	nop

000003d0 <strchr>:

char*
strchr(const char *s, char c)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 3d9:	8a 10                	mov    (%eax),%dl
 3db:	84 d2                	test   %dl,%dl
 3dd:	75 0c                	jne    3eb <strchr+0x1b>
 3df:	eb 13                	jmp    3f4 <strchr+0x24>
 3e1:	8d 76 00             	lea    0x0(%esi),%esi
 3e4:	40                   	inc    %eax
 3e5:	8a 10                	mov    (%eax),%dl
 3e7:	84 d2                	test   %dl,%dl
 3e9:	74 09                	je     3f4 <strchr+0x24>
    if(*s == c)
 3eb:	38 ca                	cmp    %cl,%dl
 3ed:	75 f5                	jne    3e4 <strchr+0x14>
      return (char*)s;
  return 0;
}
 3ef:	5d                   	pop    %ebp
 3f0:	c3                   	ret    
 3f1:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 3f4:	31 c0                	xor    %eax,%eax
}
 3f6:	5d                   	pop    %ebp
 3f7:	c3                   	ret    

000003f8 <gets>:

char*
gets(char *buf, int max)
{
 3f8:	55                   	push   %ebp
 3f9:	89 e5                	mov    %esp,%ebp
 3fb:	57                   	push   %edi
 3fc:	56                   	push   %esi
 3fd:	53                   	push   %ebx
 3fe:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 401:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 403:	8d 7d e7             	lea    -0x19(%ebp),%edi
 406:	66 90                	xchg   %ax,%ax
  for(i=0; i+1 < max; ){
 408:	8d 73 01             	lea    0x1(%ebx),%esi
 40b:	3b 75 0c             	cmp    0xc(%ebp),%esi
 40e:	7d 40                	jge    450 <gets+0x58>
    cc = read(0, &c, 1);
 410:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 417:	00 
 418:	89 7c 24 04          	mov    %edi,0x4(%esp)
 41c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 423:	e8 fb 00 00 00       	call   523 <read>
    if(cc < 1)
 428:	85 c0                	test   %eax,%eax
 42a:	7e 24                	jle    450 <gets+0x58>
      break;
    buf[i++] = c;
 42c:	8a 45 e7             	mov    -0x19(%ebp),%al
 42f:	8b 55 08             	mov    0x8(%ebp),%edx
 432:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r')
 436:	3c 0a                	cmp    $0xa,%al
 438:	74 06                	je     440 <gets+0x48>
 43a:	89 f3                	mov    %esi,%ebx
 43c:	3c 0d                	cmp    $0xd,%al
 43e:	75 c8                	jne    408 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 447:	83 c4 2c             	add    $0x2c,%esp
 44a:	5b                   	pop    %ebx
 44b:	5e                   	pop    %esi
 44c:	5f                   	pop    %edi
 44d:	5d                   	pop    %ebp
 44e:	c3                   	ret    
 44f:	90                   	nop
    if(cc < 1)
 450:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 452:	8b 45 08             	mov    0x8(%ebp),%eax
 455:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 459:	83 c4 2c             	add    $0x2c,%esp
 45c:	5b                   	pop    %ebx
 45d:	5e                   	pop    %esi
 45e:	5f                   	pop    %edi
 45f:	5d                   	pop    %ebp
 460:	c3                   	ret    
 461:	8d 76 00             	lea    0x0(%esi),%esi

00000464 <stat>:

int
stat(char *n, struct stat *st)
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	56                   	push   %esi
 468:	53                   	push   %ebx
 469:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 46c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 473:	00 
 474:	8b 45 08             	mov    0x8(%ebp),%eax
 477:	89 04 24             	mov    %eax,(%esp)
 47a:	e8 cc 00 00 00       	call   54b <open>
 47f:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 481:	85 c0                	test   %eax,%eax
 483:	78 23                	js     4a8 <stat+0x44>
    return -1;
  r = fstat(fd, st);
 485:	8b 45 0c             	mov    0xc(%ebp),%eax
 488:	89 44 24 04          	mov    %eax,0x4(%esp)
 48c:	89 1c 24             	mov    %ebx,(%esp)
 48f:	e8 cf 00 00 00       	call   563 <fstat>
 494:	89 c6                	mov    %eax,%esi
  close(fd);
 496:	89 1c 24             	mov    %ebx,(%esp)
 499:	e8 95 00 00 00       	call   533 <close>
  return r;
}
 49e:	89 f0                	mov    %esi,%eax
 4a0:	83 c4 10             	add    $0x10,%esp
 4a3:	5b                   	pop    %ebx
 4a4:	5e                   	pop    %esi
 4a5:	5d                   	pop    %ebp
 4a6:	c3                   	ret    
 4a7:	90                   	nop
    return -1;
 4a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4ad:	eb ef                	jmp    49e <stat+0x3a>
 4af:	90                   	nop

000004b0 <atoi>:

int
atoi(const char *s)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	53                   	push   %ebx
 4b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b7:	0f be 11             	movsbl (%ecx),%edx
 4ba:	8d 42 d0             	lea    -0x30(%edx),%eax
 4bd:	3c 09                	cmp    $0x9,%al
 4bf:	b8 00 00 00 00       	mov    $0x0,%eax
 4c4:	77 15                	ja     4db <atoi+0x2b>
 4c6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 4c8:	8d 04 80             	lea    (%eax,%eax,4),%eax
 4cb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 4cf:	41                   	inc    %ecx
  while('0' <= *s && *s <= '9')
 4d0:	0f be 11             	movsbl (%ecx),%edx
 4d3:	8d 5a d0             	lea    -0x30(%edx),%ebx
 4d6:	80 fb 09             	cmp    $0x9,%bl
 4d9:	76 ed                	jbe    4c8 <atoi+0x18>
  return n;
}
 4db:	5b                   	pop    %ebx
 4dc:	5d                   	pop    %ebp
 4dd:	c3                   	ret    
 4de:	66 90                	xchg   %ax,%ax

000004e0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	56                   	push   %esi
 4e4:	53                   	push   %ebx
 4e5:	8b 45 08             	mov    0x8(%ebp),%eax
 4e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 4eb:	8b 75 10             	mov    0x10(%ebp),%esi
memmove(void *vdst, void *vsrc, int n)
 4ee:	31 d2                	xor    %edx,%edx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4f0:	85 f6                	test   %esi,%esi
 4f2:	7e 0b                	jle    4ff <memmove+0x1f>
    *dst++ = *src++;
 4f4:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
 4f7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4fa:	42                   	inc    %edx
  while(n-- > 0)
 4fb:	39 f2                	cmp    %esi,%edx
 4fd:	75 f5                	jne    4f4 <memmove+0x14>
  return vdst;
}
 4ff:	5b                   	pop    %ebx
 500:	5e                   	pop    %esi
 501:	5d                   	pop    %ebp
 502:	c3                   	ret    

00000503 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 503:	b8 01 00 00 00       	mov    $0x1,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <exit>:
SYSCALL(exit)
 50b:	b8 02 00 00 00       	mov    $0x2,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <wait>:
SYSCALL(wait)
 513:	b8 03 00 00 00       	mov    $0x3,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <pipe>:
SYSCALL(pipe)
 51b:	b8 04 00 00 00       	mov    $0x4,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <read>:
SYSCALL(read)
 523:	b8 05 00 00 00       	mov    $0x5,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <write>:
SYSCALL(write)
 52b:	b8 10 00 00 00       	mov    $0x10,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <close>:
SYSCALL(close)
 533:	b8 15 00 00 00       	mov    $0x15,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <kill>:
SYSCALL(kill)
 53b:	b8 06 00 00 00       	mov    $0x6,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <exec>:
SYSCALL(exec)
 543:	b8 07 00 00 00       	mov    $0x7,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <open>:
SYSCALL(open)
 54b:	b8 0f 00 00 00       	mov    $0xf,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <mknod>:
SYSCALL(mknod)
 553:	b8 11 00 00 00       	mov    $0x11,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <unlink>:
SYSCALL(unlink)
 55b:	b8 12 00 00 00       	mov    $0x12,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <fstat>:
SYSCALL(fstat)
 563:	b8 08 00 00 00       	mov    $0x8,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <link>:
SYSCALL(link)
 56b:	b8 13 00 00 00       	mov    $0x13,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <mkdir>:
SYSCALL(mkdir)
 573:	b8 14 00 00 00       	mov    $0x14,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <chdir>:
SYSCALL(chdir)
 57b:	b8 09 00 00 00       	mov    $0x9,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <dup>:
SYSCALL(dup)
 583:	b8 0a 00 00 00       	mov    $0xa,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <getpid>:
SYSCALL(getpid)
 58b:	b8 0b 00 00 00       	mov    $0xb,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <getppid>:
SYSCALL(getppid)
 593:	b8 17 00 00 00       	mov    $0x17,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <sbrk>:
SYSCALL(sbrk)
 59b:	b8 0c 00 00 00       	mov    $0xc,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <sleep>:
SYSCALL(sleep)
 5a3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <uptime>:
SYSCALL(uptime)
 5ab:	b8 0e 00 00 00       	mov    $0xe,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <myfunction>:
SYSCALL(myfunction)
 5b3:	b8 16 00 00 00       	mov    $0x16,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <yield>:
SYSCALL(yield)
 5bb:	b8 18 00 00 00       	mov    $0x18,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <getlev>:
SYSCALL(getlev)
 5c3:	b8 19 00 00 00       	mov    $0x19,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <set_cpu_share>:
 5cb:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    
 5d3:	90                   	nop

000005d4 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5d4:	55                   	push   %ebp
 5d5:	89 e5                	mov    %esp,%ebp
 5d7:	57                   	push   %edi
 5d8:	56                   	push   %esi
 5d9:	53                   	push   %ebx
 5da:	83 ec 3c             	sub    $0x3c,%esp
 5dd:	89 c7                	mov    %eax,%edi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5df:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 5e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5e4:	85 db                	test   %ebx,%ebx
 5e6:	74 04                	je     5ec <printint+0x18>
 5e8:	85 d2                	test   %edx,%edx
 5ea:	78 5d                	js     649 <printint+0x75>
  neg = 0;
 5ec:	31 db                	xor    %ebx,%ebx
  } else {
    x = xx;
  }

  i = 0;
 5ee:	31 f6                	xor    %esi,%esi
 5f0:	eb 04                	jmp    5f6 <printint+0x22>
 5f2:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 5f4:	89 d6                	mov    %edx,%esi
 5f6:	31 d2                	xor    %edx,%edx
 5f8:	f7 f1                	div    %ecx
 5fa:	8a 92 c7 09 00 00    	mov    0x9c7(%edx),%dl
 600:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
 604:	8d 56 01             	lea    0x1(%esi),%edx
  }while((x /= base) != 0);
 607:	85 c0                	test   %eax,%eax
 609:	75 e9                	jne    5f4 <printint+0x20>
  if(neg)
 60b:	85 db                	test   %ebx,%ebx
 60d:	74 08                	je     617 <printint+0x43>
    buf[i++] = '-';
 60f:	c6 44 15 d8 2d       	movb   $0x2d,-0x28(%ebp,%edx,1)
 614:	8d 56 02             	lea    0x2(%esi),%edx

  while(--i >= 0)
 617:	8d 5a ff             	lea    -0x1(%edx),%ebx
 61a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 61d:	8d 76 00             	lea    0x0(%esi),%esi
 620:	8a 44 1d d8          	mov    -0x28(%ebp,%ebx,1),%al
 624:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 627:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 62e:	00 
 62f:	89 74 24 04          	mov    %esi,0x4(%esp)
 633:	89 3c 24             	mov    %edi,(%esp)
 636:	e8 f0 fe ff ff       	call   52b <write>
  while(--i >= 0)
 63b:	4b                   	dec    %ebx
 63c:	83 fb ff             	cmp    $0xffffffff,%ebx
 63f:	75 df                	jne    620 <printint+0x4c>
    putc(fd, buf[i]);
}
 641:	83 c4 3c             	add    $0x3c,%esp
 644:	5b                   	pop    %ebx
 645:	5e                   	pop    %esi
 646:	5f                   	pop    %edi
 647:	5d                   	pop    %ebp
 648:	c3                   	ret    
    x = -xx;
 649:	f7 d8                	neg    %eax
    neg = 1;
 64b:	bb 01 00 00 00       	mov    $0x1,%ebx
    x = -xx;
 650:	eb 9c                	jmp    5ee <printint+0x1a>
 652:	66 90                	xchg   %ax,%ax

00000654 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 654:	55                   	push   %ebp
 655:	89 e5                	mov    %esp,%ebp
 657:	57                   	push   %edi
 658:	56                   	push   %esi
 659:	53                   	push   %ebx
 65a:	83 ec 3c             	sub    $0x3c,%esp
 65d:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 660:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 663:	8a 03                	mov    (%ebx),%al
 665:	84 c0                	test   %al,%al
 667:	0f 84 bb 00 00 00    	je     728 <printf+0xd4>
printf(int fd, char *fmt, ...)
 66d:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 66e:	8d 55 10             	lea    0x10(%ebp),%edx
 671:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  state = 0;
 674:	31 ff                	xor    %edi,%edi
 676:	eb 2f                	jmp    6a7 <printf+0x53>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 678:	83 f9 25             	cmp    $0x25,%ecx
 67b:	0f 84 af 00 00 00    	je     730 <printf+0xdc>
        state = '%';
      } else {
        putc(fd, c);
 681:	88 4d e2             	mov    %cl,-0x1e(%ebp)
  write(fd, &c, 1);
 684:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 68b:	00 
 68c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 68f:	89 44 24 04          	mov    %eax,0x4(%esp)
 693:	89 34 24             	mov    %esi,(%esp)
 696:	e8 90 fe ff ff       	call   52b <write>
 69b:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 69c:	8a 43 ff             	mov    -0x1(%ebx),%al
 69f:	84 c0                	test   %al,%al
 6a1:	0f 84 81 00 00 00    	je     728 <printf+0xd4>
    c = fmt[i] & 0xff;
 6a7:	0f b6 c8             	movzbl %al,%ecx
    if(state == 0){
 6aa:	85 ff                	test   %edi,%edi
 6ac:	74 ca                	je     678 <printf+0x24>
      }
    } else if(state == '%'){
 6ae:	83 ff 25             	cmp    $0x25,%edi
 6b1:	75 e8                	jne    69b <printf+0x47>
      if(c == 'd'){
 6b3:	83 f9 64             	cmp    $0x64,%ecx
 6b6:	0f 84 14 01 00 00    	je     7d0 <printf+0x17c>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6bc:	83 f9 78             	cmp    $0x78,%ecx
 6bf:	74 7b                	je     73c <printf+0xe8>
 6c1:	83 f9 70             	cmp    $0x70,%ecx
 6c4:	74 76                	je     73c <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6c6:	83 f9 73             	cmp    $0x73,%ecx
 6c9:	0f 84 91 00 00 00    	je     760 <printf+0x10c>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6cf:	83 f9 63             	cmp    $0x63,%ecx
 6d2:	0f 84 cc 00 00 00    	je     7a4 <printf+0x150>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6d8:	83 f9 25             	cmp    $0x25,%ecx
 6db:	0f 84 13 01 00 00    	je     7f4 <printf+0x1a0>
 6e1:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
  write(fd, &c, 1);
 6e5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6ec:	00 
 6ed:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f4:	89 34 24             	mov    %esi,(%esp)
 6f7:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 6fa:	e8 2c fe ff ff       	call   52b <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 6ff:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 702:	88 4d e7             	mov    %cl,-0x19(%ebp)
  write(fd, &c, 1);
 705:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 70c:	00 
 70d:	8d 55 e7             	lea    -0x19(%ebp),%edx
 710:	89 54 24 04          	mov    %edx,0x4(%esp)
 714:	89 34 24             	mov    %esi,(%esp)
 717:	e8 0f fe ff ff       	call   52b <write>
      }
      state = 0;
 71c:	31 ff                	xor    %edi,%edi
 71e:	43                   	inc    %ebx
  for(i = 0; fmt[i]; i++){
 71f:	8a 43 ff             	mov    -0x1(%ebx),%al
 722:	84 c0                	test   %al,%al
 724:	75 81                	jne    6a7 <printf+0x53>
 726:	66 90                	xchg   %ax,%ax
    }
  }
}
 728:	83 c4 3c             	add    $0x3c,%esp
 72b:	5b                   	pop    %ebx
 72c:	5e                   	pop    %esi
 72d:	5f                   	pop    %edi
 72e:	5d                   	pop    %ebp
 72f:	c3                   	ret    
        state = '%';
 730:	bf 25 00 00 00       	mov    $0x25,%edi
 735:	e9 61 ff ff ff       	jmp    69b <printf+0x47>
 73a:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 73c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 743:	b9 10 00 00 00       	mov    $0x10,%ecx
 748:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 74b:	8b 10                	mov    (%eax),%edx
 74d:	89 f0                	mov    %esi,%eax
 74f:	e8 80 fe ff ff       	call   5d4 <printint>
        ap++;
 754:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 758:	31 ff                	xor    %edi,%edi
        ap++;
 75a:	e9 3c ff ff ff       	jmp    69b <printf+0x47>
 75f:	90                   	nop
        s = (char*)*ap;
 760:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 763:	8b 3a                	mov    (%edx),%edi
        ap++;
 765:	83 c2 04             	add    $0x4,%edx
 768:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 76b:	85 ff                	test   %edi,%edi
 76d:	0f 84 a3 00 00 00    	je     816 <printf+0x1c2>
        while(*s != 0){
 773:	8a 07                	mov    (%edi),%al
 775:	84 c0                	test   %al,%al
 777:	74 24                	je     79d <printf+0x149>
 779:	8d 76 00             	lea    0x0(%esi),%esi
 77c:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 77f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 786:	00 
 787:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 78a:	89 44 24 04          	mov    %eax,0x4(%esp)
 78e:	89 34 24             	mov    %esi,(%esp)
 791:	e8 95 fd ff ff       	call   52b <write>
          s++;
 796:	47                   	inc    %edi
        while(*s != 0){
 797:	8a 07                	mov    (%edi),%al
 799:	84 c0                	test   %al,%al
 79b:	75 df                	jne    77c <printf+0x128>
      state = 0;
 79d:	31 ff                	xor    %edi,%edi
 79f:	e9 f7 fe ff ff       	jmp    69b <printf+0x47>
        putc(fd, *ap);
 7a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 7a7:	8b 02                	mov    (%edx),%eax
 7a9:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 7ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7b3:	00 
 7b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 7b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7bb:	89 34 24             	mov    %esi,(%esp)
 7be:	e8 68 fd ff ff       	call   52b <write>
        ap++;
 7c3:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 7c7:	31 ff                	xor    %edi,%edi
 7c9:	e9 cd fe ff ff       	jmp    69b <printf+0x47>
 7ce:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 7d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 7d7:	b1 0a                	mov    $0xa,%cl
 7d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 7dc:	8b 10                	mov    (%eax),%edx
 7de:	89 f0                	mov    %esi,%eax
 7e0:	e8 ef fd ff ff       	call   5d4 <printint>
        ap++;
 7e5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
      state = 0;
 7e9:	66 31 ff             	xor    %di,%di
 7ec:	e9 aa fe ff ff       	jmp    69b <printf+0x47>
 7f1:	8d 76 00             	lea    0x0(%esi),%esi
 7f4:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
  write(fd, &c, 1);
 7f8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7ff:	00 
 800:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 803:	89 44 24 04          	mov    %eax,0x4(%esp)
 807:	89 34 24             	mov    %esi,(%esp)
 80a:	e8 1c fd ff ff       	call   52b <write>
      state = 0;
 80f:	31 ff                	xor    %edi,%edi
 811:	e9 85 fe ff ff       	jmp    69b <printf+0x47>
          s = "(null)";
 816:	bf c0 09 00 00       	mov    $0x9c0,%edi
 81b:	e9 53 ff ff ff       	jmp    773 <printf+0x11f>

00000820 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	57                   	push   %edi
 824:	56                   	push   %esi
 825:	53                   	push   %ebx
 826:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 829:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82c:	a1 d4 0c 00 00       	mov    0xcd4,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 831:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 833:	39 d0                	cmp    %edx,%eax
 835:	72 11                	jb     848 <free+0x28>
 837:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 838:	39 c8                	cmp    %ecx,%eax
 83a:	72 04                	jb     840 <free+0x20>
 83c:	39 ca                	cmp    %ecx,%edx
 83e:	72 10                	jb     850 <free+0x30>
 840:	89 c8                	mov    %ecx,%eax
 842:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 844:	39 d0                	cmp    %edx,%eax
 846:	73 f0                	jae    838 <free+0x18>
 848:	39 ca                	cmp    %ecx,%edx
 84a:	72 04                	jb     850 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84c:	39 c8                	cmp    %ecx,%eax
 84e:	72 f0                	jb     840 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 850:	8b 73 fc             	mov    -0x4(%ebx),%esi
 853:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 856:	39 cf                	cmp    %ecx,%edi
 858:	74 1a                	je     874 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 85a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 85d:	8b 48 04             	mov    0x4(%eax),%ecx
 860:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 863:	39 f2                	cmp    %esi,%edx
 865:	74 24                	je     88b <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 867:	89 10                	mov    %edx,(%eax)
  freep = p;
 869:	a3 d4 0c 00 00       	mov    %eax,0xcd4
}
 86e:	5b                   	pop    %ebx
 86f:	5e                   	pop    %esi
 870:	5f                   	pop    %edi
 871:	5d                   	pop    %ebp
 872:	c3                   	ret    
 873:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 874:	03 71 04             	add    0x4(%ecx),%esi
 877:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 87a:	8b 08                	mov    (%eax),%ecx
 87c:	8b 09                	mov    (%ecx),%ecx
 87e:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 881:	8b 48 04             	mov    0x4(%eax),%ecx
 884:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 887:	39 f2                	cmp    %esi,%edx
 889:	75 dc                	jne    867 <free+0x47>
    p->s.size += bp->s.size;
 88b:	03 4b fc             	add    -0x4(%ebx),%ecx
 88e:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 891:	8b 53 f8             	mov    -0x8(%ebx),%edx
 894:	89 10                	mov    %edx,(%eax)
  freep = p;
 896:	a3 d4 0c 00 00       	mov    %eax,0xcd4
}
 89b:	5b                   	pop    %ebx
 89c:	5e                   	pop    %esi
 89d:	5f                   	pop    %edi
 89e:	5d                   	pop    %ebp
 89f:	c3                   	ret    

000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a9:	8b 75 08             	mov    0x8(%ebp),%esi
 8ac:	83 c6 07             	add    $0x7,%esi
 8af:	c1 ee 03             	shr    $0x3,%esi
 8b2:	46                   	inc    %esi
  if((prevp = freep) == 0){
 8b3:	8b 15 d4 0c 00 00    	mov    0xcd4,%edx
 8b9:	85 d2                	test   %edx,%edx
 8bb:	0f 84 8d 00 00 00    	je     94e <malloc+0xae>
 8c1:	8b 02                	mov    (%edx),%eax
 8c3:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 8c6:	39 ce                	cmp    %ecx,%esi
 8c8:	76 52                	jbe    91c <malloc+0x7c>
 8ca:	8d 1c f5 00 00 00 00 	lea    0x0(,%esi,8),%ebx
 8d1:	eb 0a                	jmp    8dd <malloc+0x3d>
 8d3:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d4:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8d6:	8b 48 04             	mov    0x4(%eax),%ecx
 8d9:	39 ce                	cmp    %ecx,%esi
 8db:	76 3f                	jbe    91c <malloc+0x7c>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8dd:	89 c2                	mov    %eax,%edx
 8df:	3b 05 d4 0c 00 00    	cmp    0xcd4,%eax
 8e5:	75 ed                	jne    8d4 <malloc+0x34>
  if(nu < 4096)
 8e7:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
 8ed:	76 4d                	jbe    93c <malloc+0x9c>
 8ef:	89 d8                	mov    %ebx,%eax
 8f1:	89 f7                	mov    %esi,%edi
  p = sbrk(nu * sizeof(Header));
 8f3:	89 04 24             	mov    %eax,(%esp)
 8f6:	e8 a0 fc ff ff       	call   59b <sbrk>
  if(p == (char*)-1)
 8fb:	83 f8 ff             	cmp    $0xffffffff,%eax
 8fe:	74 18                	je     918 <malloc+0x78>
  hp->s.size = nu;
 900:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 903:	83 c0 08             	add    $0x8,%eax
 906:	89 04 24             	mov    %eax,(%esp)
 909:	e8 12 ff ff ff       	call   820 <free>
  return freep;
 90e:	8b 15 d4 0c 00 00    	mov    0xcd4,%edx
      if((p = morecore(nunits)) == 0)
 914:	85 d2                	test   %edx,%edx
 916:	75 bc                	jne    8d4 <malloc+0x34>
        return 0;
 918:	31 c0                	xor    %eax,%eax
 91a:	eb 18                	jmp    934 <malloc+0x94>
      if(p->s.size == nunits)
 91c:	39 ce                	cmp    %ecx,%esi
 91e:	74 28                	je     948 <malloc+0xa8>
        p->s.size -= nunits;
 920:	29 f1                	sub    %esi,%ecx
 922:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 925:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 928:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 92b:	89 15 d4 0c 00 00    	mov    %edx,0xcd4
      return (void*)(p + 1);
 931:	83 c0 08             	add    $0x8,%eax
  }
}
 934:	83 c4 1c             	add    $0x1c,%esp
 937:	5b                   	pop    %ebx
 938:	5e                   	pop    %esi
 939:	5f                   	pop    %edi
 93a:	5d                   	pop    %ebp
 93b:	c3                   	ret    
  if(nu < 4096)
 93c:	b8 00 80 00 00       	mov    $0x8000,%eax
    nu = 4096;
 941:	bf 00 10 00 00       	mov    $0x1000,%edi
 946:	eb ab                	jmp    8f3 <malloc+0x53>
        prevp->s.ptr = p->s.ptr;
 948:	8b 08                	mov    (%eax),%ecx
 94a:	89 0a                	mov    %ecx,(%edx)
 94c:	eb dd                	jmp    92b <malloc+0x8b>
    base.s.ptr = freep = prevp = &base;
 94e:	c7 05 d4 0c 00 00 d8 	movl   $0xcd8,0xcd4
 955:	0c 00 00 
 958:	c7 05 d8 0c 00 00 d8 	movl   $0xcd8,0xcd8
 95f:	0c 00 00 
    base.s.size = 0;
 962:	c7 05 dc 0c 00 00 00 	movl   $0x0,0xcdc
 969:	00 00 00 
 96c:	b8 d8 0c 00 00       	mov    $0xcd8,%eax
 971:	e9 54 ff ff ff       	jmp    8ca <malloc+0x2a>
