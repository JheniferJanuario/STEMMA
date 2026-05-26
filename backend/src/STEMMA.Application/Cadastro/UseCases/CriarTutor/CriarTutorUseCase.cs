namespace STEMMA.Application.Cadastro.UseCases.CriarTutor;

public class CriarTutorUseCase : ICriarTutorUseCase
{
    public string Executar(string nome)
    {
        return $"Tutor {nome} criado com sucesso";
    }
}