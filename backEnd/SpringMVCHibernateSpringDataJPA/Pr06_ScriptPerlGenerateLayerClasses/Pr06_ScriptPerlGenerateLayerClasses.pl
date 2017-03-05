use strict;
use warnings;
use Cwd;

sub main {

	my $entitPack   = '';    # entities
	my $repoPack    = '';    # repository
	my $servPack    = '';    # service
	my $controlPack = '';    # controller
	my $nameFile    = '';
	my $lowerName   = '';

	my $packEnt = '';
	my $packRep = '';
	my $packSer = '';
	my $packCon = '';

	my $repoDir    = '';
	my $serviceDir = '';
	my $controlDir = '';

	my $search_package = 'package';
	my $search_class   = 'public class';
	#my $thePath = '/home/jarana/workspace/JpaEcomm/src/main/java/com/jarana/entities';
	my $thePath = $ARGV[0];

	print "originalPath:" . $thePath . "\n";

	#-- change dir to ../
	chdir $thePath;

	chdir("../");
	my $dir = getcwd;
	print "AfterPwd:" . $dir . "\n";

	$entitPack = `find . -type d -iname "entit*"`;
	$entitPack =~ s/\.\///;
	my $entlen = length $entitPack;
	$entlen = $entlen - 1;
	print "entlen:" . $entlen . "\n";

	#to delete
	print "entitRepo:" . $entitPack . "\n";

	$repoDir = `find $dir -type d -iname "repo*"`;

	if ( $repoDir eq '' ) {
		$repoPack = 'repository';
		unless ( -e $repoPack or mkdir $repoPack ) {
			die "Unable to create $repoPack\n";
		}
		$repoDir = `find $dir -type d -iname "repo*"`;
	}
	else {
		$repoPack = `find . -type d -iname "repo*"`;
		$repoPack =~ s/\.\///;
		substr( $repoPack, -1 ) = '';    # Removing last char (;)
		print "repoPack:" . $repoPack . "\n";

	}

	#to delete
	print "repoDir:" . $repoDir . "\n";
	print "repoPack:" . $repoPack . "\n";

	$serviceDir = `find $dir -type d -iname "serv*"`;

	if ( $serviceDir eq '' ) {
		$servPack = 'service';
		unless ( -e $servPack or mkdir $servPack ) {
			die "Unable to create $repoPack\n";
		}
		$serviceDir = `find $dir -type d -iname "serv*"`;
	}
	else {
		$servPack = `find . -type d -iname "serv*"`;
		$servPack =~ s/\.\///;
	}

	#to delete
	print "serviceDir:" . $serviceDir . "\n";
	print "servPack:" . $servPack . "\n";

	$controlDir = `find $dir -type d -iname "contro*"`;
	if ( $controlDir eq '' ) {
		$controlPack = 'controller';
		unless ( -e $controlPack or mkdir $controlPack ) {
			die "Unable to create $repoPack\n";
		}
		$controlDir = `find $dir -type d -iname "contro*"`;
	}
	else {
		$controlPack = `find . -type d -iname "contro*"`;
		$controlPack =~ s/\.\///;
	}

	#to delete
	print "controlDir:" . $controlDir . "\n";
	print "controlPack:" . $controlPack . "\n";

	print "+++++++++++++++++++++++++++\n";

	chdir($thePath);
	print "Before iterating, path:" . $dir . "\n";

	my @default_files = glob "$thePath" . '/*';
	my $fls           = '';
	my $actualdDir    = '';


	foreach $fls (@default_files) {

		#chomp($fls);
		if ( -f $fls ) {
			print "$fls\n";
			$nameFile = $fls;
			$nameFile =~ s{.*/}{};         # removes path
			$nameFile =~ s{\.[^.]+$}{};    # removes extension
			$lowerName = lc $nameFile;

			#my @Id = ();
			my $file_to_get = $fls;
			print
			"+++++++++++++++++++++ Iteration +++++++++++++++++++++++++++++++++++\n";
			print "fls:" . $fls . "\n";
			
			my $actualINPUTDir = getcwd;
			#print "actualINPUTDir:" . $actualINPUTDir . "\n";
				
			open( INPUT, $file_to_get ) or die "Can't open '$file_to_get': $!";

			while ( my $line = <INPUT> ) {
				if ( $line =~ /$search_package/ ) {

					#Obtaining the package, extract next word from class
					$line =~ /$search_package\s*?(\S+)/;
					my $packEnt = $1;
					substr( $packEnt, -1 ) = '';    # Removing last char (;)
					print "packEnt:" . $packEnt . "<----------------\n";

					$packRep = $packEnt;
					substr( $packRep, -$entlen ) = '';
					$packRep = $packRep . $repoPack;
					print "packRep:" . $packRep . "\n";

					$packSer = $packEnt;
					substr( $packSer, -$entlen ) = '';
					$packSer = $packSer . $servPack;
					print "packSer:" . $packSer . "\n";

					$packCon = $packEnt;
					substr( $packCon, -$entlen ) = '';
					$packCon = $packCon . $controlPack;
					print "packCon:" . $packCon . "\n";
					
					print " ++++++++++++++ FILES +++++++++++++++++\n";
					# REPOSITORY FILES
					chdir("../repository");
					my $REPout = $nameFile . "DAO.java";
					#print "REPout:" . $REPout . "\n";
					my $dir4 = getcwd;
					#print "dir4" . $dir4 . "\n";

					open( OUTPUT, '>', $REPout ) or die("Can't open $REPout");
					print OUTPUT "package " . $packRep . ";\n";

					print OUTPUT "import java.util.List;\n\n";
					print OUTPUT "import org.springframework.data.jpa.repository.JpaRepository;\n";
					print OUTPUT
					  "import org.springframework.stereotype.Repository;\n\n";
					print OUTPUT "import ". $packEnt . ".". $nameFile . ";" . "\n\n";
					print OUTPUT "\@Repository(\"" . $lowerName . "DAO\")\n";
					print OUTPUT "public interface ". $nameFile. "DAO extends JpaRepository<". $nameFile. ", TypePK> {\n\n";

					print OUTPUT "\t List<".$nameFile."> findBy-ReplaceFIELD(TYPE FIELD);\n";
					print OUTPUT "}\n";
					close(OUTPUT);
					print "** RepoFile:" . getcwd . "/" . $REPout . "\n";

					# SERVICE FILES
					chdir("../service");
					my $SERVout = $nameFile . "Service.java";
					#print "SERVout:" . $SERVout . "\n";
					$dir4 = getcwd;
					#print "dir4" . $dir4 . "\n";

					substr( $packSer, -1 ) = '';    # Removing last char (;)
					#print "package " . $packSer . "; <<<<<<<<\n";

					open( OUTPUT, '>', $SERVout ) or die("Can't open $REPout");
					print OUTPUT "package " . $packSer . ";\n";

					print OUTPUT "import java.util.List;\n\n";
					print OUTPUT "import ". $packEnt . ".". $nameFile . ";\n";
					print OUTPUT "public interface ". $nameFile. "Service {\n";
					print OUTPUT "\tpublic List<".$nameFile."> findAll();\n";
					print OUTPUT "\/\/\tpublic ".$nameFile." findOne(TYPE PK);\n";
					print OUTPUT "\/\/\tpublic List<".$nameFile."> findBy-ReplaceFIELD(TYPE FIELD);\n";
					print OUTPUT "\tpublic void create (". $nameFile . " ". $lowerName . ");\n";
					print OUTPUT "\tpublic void update (". $nameFile . " ". $lowerName . ");\n";
					print OUTPUT "\tpublic void delete (". $nameFile . " ". $lowerName . ");\n";

					print OUTPUT "}\n";
					close(OUTPUT);
					print "** ServFile:" . getcwd . "/" . $SERVout . "\n";

					# SERVICE IMPL
					my $SERVImpOut = $nameFile . "ServiceImpl.java";
					#print "SERVImpOut:" . $SERVImpOut . "\n";

					open( OUTPUT, '>', $SERVImpOut )
					  or die("Can't open $REPout");
					print OUTPUT "package " . $packSer . ";\n";

					print OUTPUT "import java.util.List;\n\n";
					print OUTPUT "import org.springframework.beans.factory.annotation.Autowired;\n";
					print OUTPUT "import org.springframework.stereotype.Service;\n";
					print OUTPUT "import org.springframework.transaction.annotation.Transactional;\n\n";
					print OUTPUT "import " . $packEnt . "." . $nameFile . ";\n";
					print OUTPUT "import ". $packRep . ".". $nameFile. "DAO;\n\n";
					print OUTPUT "\@Transactional\n";
					print OUTPUT "\@Service(\"" . $lowerName . "Service\")\n";
					print OUTPUT "public class ". $nameFile. "ServiceImpl implements ". $nameFile. "Service {\n\n";
					print OUTPUT "\t\@Autowired\n";
					print OUTPUT "\tprivate ". $nameFile . "DAO ". $lowerName. "DAO;\n\n";
					
					print OUTPUT "\tpublic List<".$nameFile."> findAll() {\n";
					print OUTPUT "\t\tList<". $nameFile. "> list".$nameFile." = ".$lowerName. "DAO.findAll();\n";
					print OUTPUT "\t\treturn list".$nameFile.";\n";
					print OUTPUT "\t}\n\n";
					
					print OUTPUT "\/\/\tpublic ".$nameFile." findOne(TYPE PK) {\n";
					print OUTPUT "\/\/\t\treturn ".$lowerName. "DAO.findOne(PK);\n";
					print OUTPUT "\/\/\t}\n\n";
					
					print OUTPUT "\/\/\tpublic List<".$nameFile."> findBy-ReplaceFIELD(TYPE FIELD) {\n";
					print OUTPUT "\/\/\t\treturn ".$lowerName. "DAO.findBy-ReplaceFIELD(FIELD);\n";
					print OUTPUT "\/\/\t}\n\n";
					
					print OUTPUT "\tpublic void create (". $nameFile . " ". $lowerName . ") {\n";
					print OUTPUT "\t\t". $lowerName. "DAO.save(". $lowerName . ");\n";
					print OUTPUT "\t}\n\n";
					
					print OUTPUT "\tpublic void update (". $nameFile . " ". $lowerName . ") {\n";
					print OUTPUT "\t\t". $lowerName. "DAO.save(". $lowerName . ");\n";
					print OUTPUT "\t}\n\n";
					
					print OUTPUT "\tpublic void delete (". $nameFile . " ". $lowerName . ") {\n";
					print OUTPUT "\t\t". $lowerName. "DAO.delete(". $lowerName . ");\n";
					print OUTPUT "\t}\n\n";
					
					print OUTPUT "}\n";
					close(OUTPUT);
					print "** ServImplFile:". getcwd . "/". $SERVImpOut . "\n";
					
					
					# CONTROLLER
					chdir("../controller");
					my $ContrOut = $nameFile . "Controller.java";
					#print "ContrOut:" . $ContrOut . "\n";

					open( OUTPUT, '>', $ContrOut )
					  or die("Can't open $ContrOut");
					#$packCon = $packCon.";";
					substr( $packCon, -1 ) = '';    # Removing last char (;)
					print "package " . $packCon . ";\n";
					print OUTPUT "package " . $packCon . ";\n";

					print OUTPUT "import java.util.List;\n\n";
					print OUTPUT "import org.springframework.beans.factory.annotation.Autowired;\n";
					print OUTPUT "import org.springframework.http.MediaType;\n";
					print OUTPUT "import org.springframework.stereotype.Controller;\n";
					print OUTPUT "import org.springframework.ui.Model;\n";
					print OUTPUT "import org.springframework.web.bind.annotation.PathVariable;\n";
					print OUTPUT "import org.springframework.web.bind.annotation.RequestBody;\n";
					print OUTPUT "import org.springframework.web.bind.annotation.RequestMapping;\n";
					print OUTPUT "import org.springframework.web.bind.annotation.RequestMethod;\n";
					print OUTPUT "import org.springframework.web.bind.annotation.ResponseBody;\n\n";
					
					print OUTPUT "import " . $packEnt . "." . $nameFile . ";\n";
					print OUTPUT "import ". $packSer . ".". $nameFile. "Service;\n\n";
					
					print OUTPUT "\@Controller\n";
					print OUTPUT "\@RequestMapping(\"\/" . $lowerName . "\")\n";
					print OUTPUT "public class ". $nameFile. "Controller { \n\n";
					print OUTPUT "\t\@Autowired\n";
					print OUTPUT "\tprivate ". $nameFile . "Service ". $lowerName. "Service;\n\n";
					
					
					print OUTPUT "\t\@RequestMapping(method = RequestMethod.GET)\n";
					print OUTPUT "\t\@ResponseBody\n";
					print OUTPUT "\tpublic List<".$nameFile."> findAll() {\n";
					print OUTPUT "\t\treturn ". $lowerName. "Service.findAll();\n";
					print OUTPUT "\t}\n\n";
					
					print OUTPUT "\/\/\t\@RequestMapping(value = \"\/{id}\", method = RequestMethod.GET)\n";
					print OUTPUT "\/\/\t\@ResponseBody\n";
					print OUTPUT "\/\/\tpublic ".$nameFile." find(\@PathVariable(\"id\") Type id) {\n";
					print OUTPUT "\/\/\t\treturn ". $lowerName. "Service.findOne(id);\n";
					print OUTPUT "\/\/\t}\n\n";
					
					print OUTPUT "\/\/\t\@RequestMapping(value = \"\/WISHED_FIELD_NAME\/{FIELD}\", method = RequestMethod.GET)\n";
					print OUTPUT "\/\/\t\@ResponseBody\n";
					print OUTPUT "\/\/\tpublic List<".$nameFile."> findBy-ReplaceFIELD(\@PathVariable(\"FIELD\") TYPE FIELD) {\n";
					print OUTPUT "\/\/\t\treturn ". $lowerName. "Service.findBy-ReplaceFIELD(FIELD);\n";
					print OUTPUT "\/\/\t}\n\n";
					
					
					print OUTPUT "\t\@RequestMapping(value = \"\/add"."\", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)\n";
					print OUTPUT "\t\@ResponseBody\n";
					print OUTPUT "\tpublic void create(\@RequestBody ". $nameFile . " ". $lowerName . ") {\n";
					print OUTPUT "\t\t". $lowerName. "Service.create(". $lowerName . ");\n";
					print OUTPUT "\t}\n\n";
					
					print OUTPUT "\t\@RequestMapping(value = \"\/edit"."\", method = RequestMethod.PUT, consumes = MediaType.APPLICATION_JSON_VALUE)\n";
					print OUTPUT "\t\@ResponseBody\n";
					print OUTPUT "\tpublic void update(\@RequestBody ". $nameFile . " ". $lowerName . ") {\n";
					print OUTPUT "\t\t". $lowerName. "Service.update(". $lowerName . ");\n";
					print OUTPUT "\t}\n\n";
					
					print OUTPUT "\t\@RequestMapping(value = \"\/delete"."\", method = RequestMethod.DELETE)\n";
					print OUTPUT "\t\@ResponseBody\n";
					print OUTPUT "\tpublic void delete(\@RequestBody ". $nameFile . " ". $lowerName . ") {\n";
					print OUTPUT "\t\t". $lowerName. "Service.delete(". $lowerName . ");\n";
					print OUTPUT "\t}\n\n";
					print OUTPUT "}\n";
					close(OUTPUT);
					print "** ControllerFile:". getcwd . "/". $ContrOut . "\n";


				} # if ( $line =~ /$search_package/ ) {
				


			} # while ( my $line = <INPUT> ) {
		} # if ( -f $fls ) {
	}  # foreach $fls (@default_files) {
		
	# Create HelloController
	
	chdir("../controller");
	$nameFile="Hello";
	my $ContrHello = "HelloController.java";
	#print "ContrHello:" . $ContrHello . "\n";

	open( OUTPUT, '>', $ContrHello ) or die("Can't open $ContrHello");
	#substr( $packCon, -1 ) = '';    # Removing last char (;)
	print "package " . $packCon . ";\n";
	print OUTPUT "package " . $packCon . ";\n";
	print OUTPUT "import org.springframework.stereotype.Controller;\n";
	print OUTPUT "iimport org.springframework.ui.Model;\n";
	print OUTPUT "import org.springframework.web.bind.annotation.RequestMapping;\n";
	print OUTPUT "import org.springframework.web.bind.annotation.ResponseBody;\n\n";
	
	print OUTPUT "\@Controller\n";
	print OUTPUT "\@RequestMapping(value = \"\/\")\n";
	print OUTPUT "public class ". $nameFile. "Controller { \n\n";
	print OUTPUT "\t\@RequestMapping\n";
	print OUTPUT "\t\@ResponseBody\n";
	print OUTPUT "\tpublic String sayHello(Model model) {\n";
	print OUTPUT "\t\tmodel.addAttribute(\"greeting\",\"Hello World from Web Services\");\n";
	print OUTPUT "\t\treturn \"index\";\n";
	print OUTPUT "\t}\n\n";
	print OUTPUT "}\n\n";
				
	
} # main

main();
